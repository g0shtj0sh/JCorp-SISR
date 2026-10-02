#requires -Modules ActiveDirectory, GroupPolicy
<#
.SYNOPSIS
  Cree les GPO JCorp de l'AP 1 sur le domaine ad.jcorp.
.EXAMPLE
  .\JCORP-GPO.ps1 -WhatIf
  .\JCORP-GPO.ps1
.NOTES
  A lancer dans Windows PowerShell 5.1 en administrateur de domaine sur JCORP-DC01.
  Les lecteurs reseau demandent des chemins de partage reels et ne sont pas crees ici.
  Le mot de passe LAPS n'est jamais defini dans ce fichier.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [switch]$ConfigureLaps
)

$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory
Import-Module GroupPolicy

$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'ad.jcorp') { throw "Domaine inattendu : $($domain.DNSRoot). Attendu : ad.jcorp." }
$base = $domain.DistinguishedName
$ouUsers = "OU=Utilisateurs,$base"
$ouComputers = "OU=Postes,$base"
$ouServers = "OU=Serveurs,$base"
foreach ($ou in @($ouUsers, $ouComputers, $ouServers)) {
    if (-not (Get-ADOrganizationalUnit -Identity $ou -ErrorAction SilentlyContinue)) { throw "OU absente : $ou" }
}

$requiredGroups = @('GG_DSI', 'GG_Developpement', 'GG_RH', 'GG_Comptabilite', 'GG_Juridique', 'GG_Direction')
foreach ($group in $requiredGroups) {
    if (-not (Get-ADGroup -Identity $group -ErrorAction SilentlyContinue)) { throw "Groupe absent : $group" }
}

function Ensure-Gpo {
    param([string]$Name, [string]$Target, [string]$Comment)
    $gpo = Get-GPO -Name $Name -ErrorAction SilentlyContinue
    if (-not $gpo) {
        if ($PSCmdlet.ShouldProcess($Name, 'Creer la GPO')) {
            $gpo = New-GPO -Name $Name -Comment $Comment
        }
    }
    if ($gpo) {
        $link = Get-GPInheritance -Target $Target
        if (-not ($link.GpoLinks | Where-Object { $_.DisplayName -eq $Name })) {
            if ($PSCmdlet.ShouldProcess($Target, "Lier $Name")) { New-GPLink -Name $Name -Target $Target | Out-Null }
        }
    }
    return $gpo
}

function Set-PolicyDword {
    param([string]$Gpo, [string]$Key, [string]$Name, [int]$Value)
    if ($PSCmdlet.ShouldProcess($Gpo, "Definir $Key\$Name = $Value")) {
        Set-GPRegistryValue -Name $Gpo -Key $Key -ValueName $Name -Type DWord -Value $Value | Out-Null
    }
}

function Set-GroupFilter {
    param([string]$Gpo, [string[]]$Groups)
    if ($PSCmdlet.ShouldProcess($Gpo, "Application reservee a $($Groups -join ', ')")) {
        Set-GPPermission -Name $Gpo -TargetName 'Authenticated Users' -TargetType Group -PermissionLevel GpoRead -Replace | Out-Null
        foreach ($group in $Groups) {
            Set-GPPermission -Name $Gpo -TargetName $group -TargetType Group -PermissionLevel GpoApply -Replace | Out-Null
        }
    }
}

# Verrouillage automatique au bout de 10 minutes d'inactivite.
$g = 'JCORP-Postes-Verrouillage'
Ensure-Gpo $g $ouComputers 'Verrouille les postes apres 10 minutes' | Out-Null
Set-PolicyDword $g 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' 'InactivityTimeoutSecs' 600

# Pare-feu Windows sur les profils domaine, prive et public.
$g = 'JCORP-Postes-PareFeu'
Ensure-Gpo $g $ouComputers 'Active le pare-feu Windows' | Out-Null
foreach ($profile in @('DomainProfile', 'StandardProfile', 'PublicProfile')) {
    Set-PolicyDword $g "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\$profile" 'EnableFirewall' 1
}

# Mises a jour automatiques : installation programmee a 03:00.
$g = 'JCORP-Postes-MisesAJour'
Ensure-Gpo $g $ouComputers 'Installe automatiquement les mises a jour Windows' | Out-Null
$updateKey = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
Set-PolicyDword $g $updateKey 'AUOptions' 4
Set-PolicyDword $g $updateKey 'ScheduledInstallDay' 0
Set-PolicyDword $g $updateKey 'ScheduledInstallTime' 3
Set-PolicyDword $g $updateKey 'NoAutoRebootWithLoggedOnUsers' 1

# Conservation de journaux plus grands sur les serveurs (64 Mio chacun).
$g = 'JCORP-Serveurs-Journaux'
Ensure-Gpo $g $ouServers 'Augmente la taille des journaux Windows des serveurs' | Out-Null
foreach ($logName in @('Application', 'Security', 'System')) {
    Set-PolicyDword $g "HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\$logName" 'MaxSize' 67108864
}

# CMD interdit par defaut aux utilisateurs, autorise pour DSI et Developpement.
# DisableCMD=2 interdit la console interactive mais garde les scripts .bat/.cmd.
$cmdKey = 'HKCU\Software\Policies\Microsoft\Windows\System'
$g = 'JCORP-Utilisateurs-CMD-Bloque'
Ensure-Gpo $g $ouUsers 'Interdit CMD aux utilisateurs standards' | Out-Null
Set-PolicyDword $g $cmdKey 'DisableCMD' 2
$cmdException = 'JCORP-Utilisateurs-CMD-Autorise'
Ensure-Gpo $cmdException $ouUsers 'Autorise CMD a la DSI et au Developpement' | Out-Null
Set-PolicyDword $cmdException $cmdKey 'DisableCMD' 0
Set-GroupFilter $cmdException @('GG_DSI', 'GG_Developpement')

# Editeur du registre interdit par defaut, autorise pour la DSI.
$regKey = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System'
$g = 'JCORP-Utilisateurs-Regedit-Bloque'
Ensure-Gpo $g $ouUsers 'Interdit Regedit aux utilisateurs standards' | Out-Null
Set-PolicyDword $g $regKey 'DisableRegistryTools' 1
$regException = 'JCORP-Utilisateurs-Regedit-Autorise'
Ensure-Gpo $regException $ouUsers 'Autorise Regedit a la DSI' | Out-Null
Set-PolicyDword $regException $regKey 'DisableRegistryTools' 0
Set-GroupFilter $regException @('GG_DSI')

# Ecriture sur les supports USB refusee aux groupes traitant des donnees sensibles.
$g = 'JCORP-Utilisateurs-USB-LectureSeule'
Ensure-Gpo $g $ouUsers 'Lecture seule des supports amovibles pour les services sensibles' | Out-Null
Set-PolicyDword $g 'HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}' 'Deny_Write' 1
Set-GroupFilter $g @('GG_RH', 'GG_Comptabilite', 'GG_Juridique', 'GG_Direction')

# Les GPO d'exception doivent avoir une priorite superieure aux blocages.
foreach ($name in @($cmdException, $regException)) {
    if ($PSCmdlet.ShouldProcess($name, 'Definir la priorite du lien a 1')) {
        Set-GPLink -Name $name -Target $ouUsers -Order 1 | Out-Null
    }
}

# LAPS est facultatif car il demande le schema et les droits AD adequats.
if ($ConfigureLaps) {
    $schema = (Get-ADRootDSE).schemaNamingContext
    if (-not (Get-ADObject -SearchBase $schema -LDAPFilter '(lDAPDisplayName=msLAPS-Password)' -ErrorAction SilentlyContinue)) {
        throw 'Schema Windows LAPS absent. Executer Update-LapsADSchema et configurer les droits avant -ConfigureLaps.'
    }
    $g = 'JCORP-Postes-LAPS'
    Ensure-Gpo $g $ouComputers 'Sauvegarde les mots de passe administrateur local dans AD avec Windows LAPS' | Out-Null
    $lapsKey = 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS'
    Set-PolicyDword $g $lapsKey 'BackupDirectory' 2
    Set-PolicyDword $g $lapsKey 'PasswordLength' 16
    Set-PolicyDword $g $lapsKey 'PasswordAgeDays' 30
    Set-PolicyDword $g $lapsKey 'PasswordComplexity' 4
}

Write-Host 'GPO JCorp traitees. Verifier les liens et les filtres dans GPMC, puis tester avec gpresult /r sur un poste joint au domaine.' -ForegroundColor Cyan

