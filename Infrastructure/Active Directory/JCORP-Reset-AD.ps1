# Reinitialise uniquement la structure JCorp creee pour cette maquette.
# Executer sur JCORP-DC01 dans Windows PowerShell ISE en administrateur.
Import-Module ActiveDirectory
$ErrorActionPreference = 'Stop'

$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'ad.jcorp') {
    throw "Domaine inattendu : $($domain.DNSRoot)"
}
$base = $domain.DistinguishedName
$rootNames = @('Administration', 'Groupes', 'Postes', 'Serveurs', 'Utilisateurs')
$services = @(
    'Direction', 'DSI', 'Reseau_Systeme', 'RH', 'Comptabilite',
    'Juridique', 'Secretariat', 'Communication', 'Redaction',
    'Developpement', 'Commercial', 'Labo_Recherche', 'Accueil', 'Securite'
)
$roles = @('Visiteurs_Medicaux', 'Delegues_Regionaux', 'Responsables_Secteur')
$groupNames = @($services | ForEach-Object { "GG_$_" }) +
              @($roles | ForEach-Object { "GG_$_" })
$roster = @'
Service,Given,Surname,Sam,Role
Direction,Joshua,Fernandes,jfernandes,
Direction,Amelie,Robert,arobert,
Direction,Sophie,Perrin,sperrin,
DSI,Camille,Moreau,cmoreau,
DSI,Mehdi,Fournier,mfournier,
DSI,Pauline,Chevalier,pchevalier,
Reseau_Systeme,Nicolas,Bernard,nbernard,
Reseau_Systeme,Alexandre,Legrand,alegrand,
Reseau_Systeme,Manon,Faure,mfaure,
RH,Sarah,Lefevre,slefevre,
RH,Elodie,Gauthier,egauthier,
RH,Victor,Herve,vherve,
Comptabilite,Thomas,Petit,tpetit,
Comptabilite,Claire,Boyer,cboyer,
Comptabilite,Julien,Masson,jmasson,
Juridique,Lea,Dubois,ldubois,
Juridique,Adrien,Blanc,ablanc,
Juridique,Marion,Leroy,mleroy,
Secretariat,Hugo,Martin,hmartin,
Secretariat,Anais,Renaud,arenaud,
Secretariat,Baptiste,Marchand,bmarchand,
Communication,Emma,Laurent,elaurent,
Communication,Noemie,Barbier,nbarbier,
Communication,Mathis,Duval,mduval,
Redaction,Lucas,Michel,lmichel,
Redaction,Pauline,Colin,pcolin,
Redaction,Arthur,Vidal,avidal,
Developpement,Ines,Roux,iroux,
Developpement,Yanis,Lopez,ylopez,
Developpement,Lucie,Brun,lbrun,
Commercial,Julie,Mercier,jmercier,GG_Visiteurs_Medicaux
Commercial,Karim,Benoit,kbenoit,GG_Delegues_Regionaux
Commercial,Antoine,Garcia,agarcia,GG_Responsables_Secteur
Labo_Recherche,Chloe,Fontaine,cfontaine,
Labo_Recherche,Romain,Andre,randre,
Labo_Recherche,Salome,Renard,srenard,
Accueil,Maxime,Girard,mgirard,
Accueil,Nadia,Moulin,nmoulin,
Accueil,Theo,Bertrand,tbertrand,
Securite,Nora,Lambert,nlambert,
Securite,Damien,Perrot,dperrot,
Securite,Melanie,Caron,mcaron,
'@
$people = $roster | ConvertFrom-Csv
$oldNamedAccounts = @(
    'jfernandes', 'cmoreau', 'nbernard', 'slefevre', 'tpetit',
    'ldubois', 'hmartin', 'elaurent', 'lmichel', 'iroux',
    'agarcia', 'cfontaine', 'mgirard', 'nlambert',
    'jmercier', 'kbenoit', 'sperrin'
)
$previousDemoNames = @($services | ForEach-Object { "demo.$($_.ToLower())" }) +
                     @('demo.visiteur', 'demo.delegue', 'demo.responsable')
$accountNames = @($people | ForEach-Object { $_.Sam }) + $oldNamedAccounts + $previousDemoNames
$expectedOUs = @($rootNames) + @($services)

function Get-ChildOU([string]$name, [string]$parent) {
    @(Get-ADOrganizationalUnit -Filter "Name -eq '$name'" -SearchBase $parent -SearchScope OneLevel)
}

# Controle avant toute suppression : ne jamais effacer un compte, groupe ou objet inattendu.
$existingRoots = @()
foreach ($name in $rootNames) {
    $existingRoots += @(Get-ChildOU $name $base)
}
if ($existingRoots.Count -gt 0 -and $existingRoots.Count -ne $rootNames.Count) {
    throw 'Structure JCorp partielle : aucun objet modifie. Verifier les OU racine.'
}

foreach ($root in $existingRoots) {
    $objects = @(Get-ADObject -Filter * -SearchBase $root.DistinguishedName -SearchScope Subtree -Properties sAMAccountName)
    foreach ($obj in $objects) {
        switch ($obj.ObjectClass) {
            'organizationalUnit' {
                if ($obj.Name -notin $expectedOUs) {
                    throw "OU inattendue : $($obj.DistinguishedName). Aucun objet modifie."
                }
            }
            'group' {
                if ($obj.sAMAccountName -notin $groupNames -or $root.Name -ne 'Groupes') {
                    throw "Groupe inattendu : $($obj.DistinguishedName). Aucun objet modifie."
                }
            }
            'user' {
                if ($obj.sAMAccountName -notin $accountNames -or $root.Name -ne 'Utilisateurs') {
                    throw "Utilisateur inattendu : $($obj.DistinguishedName). Aucun objet modifie."
                }
            }
            default {
                throw "Objet inattendu : $($obj.DistinguishedName). Aucun objet modifie."
            }
        }
    }
}

# Verifier que les noms de groupe et de compte ne sont pas deja utilises ailleurs.
foreach ($name in $groupNames) {
    $found = Get-ADGroup -Filter "SamAccountName -eq '$name'"
    if ($found -and $found.DistinguishedName -notlike "*,OU=Groupes,$base") {
        throw "Nom de groupe utilise ailleurs : $name. Aucun objet modifie."
    }
}
foreach ($name in $accountNames) {
    $found = Get-ADUser -Filter "SamAccountName -eq '$name'"
    if ($found -and $found.DistinguishedName -notlike "*,OU=Utilisateurs,$base") {
        throw "Nom de compte utilise ailleurs : $name. Aucun objet modifie."
    }
}

# Supprimer la structure existante, apres les controles ci-dessus.
foreach ($root in $existingRoots) {
    Get-ADOrganizationalUnit -Filter * -SearchBase $root.DistinguishedName |
        Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false
    Remove-ADObject -Identity $root.DistinguishedName -Recursive -Confirm:$false
    Write-Host "OU reinitialisee : $($root.Name)"
}

# Creer les cinq OU directement sous ad.jcorp.
foreach ($name in $rootNames) {
    New-ADOrganizationalUnit -Name $name -Path $base -ProtectedFromAccidentalDeletion $false
}
$usersPath = "OU=Utilisateurs,$base"
$groupsPath = "OU=Groupes,$base"

# Creer les OU de service et les groupes globaux de securite.
foreach ($service in $services) {
    New-ADOrganizationalUnit -Name $service -Path $usersPath -ProtectedFromAccidentalDeletion $false
    $group = "GG_$service"
    New-ADGroup -Name $group -SamAccountName $group -GroupScope Global `
        -GroupCategory Security -Path $groupsPath -Description "Personnel du service $service"
}
foreach ($role in $roles) {
    $group = "GG_$role"
    New-ADGroup -Name $group -SamAccountName $group -GroupScope Global `
        -GroupCategory Security -Path $groupsPath -Description "Fonction commerciale $role"
}

# Comptes nominatifs fictifs : trois par service.
$password = Read-Host 'Mot de passe initial des comptes' -AsSecureString
foreach ($person in $people) {
    New-ADUser -Name "$($person.Given) $($person.Surname)" `
        -GivenName $person.Given -Surname $person.Surname `
        -DisplayName "$($person.Given) $($person.Surname)" `
        -SamAccountName $person.Sam `
        -UserPrincipalName "$($person.Sam)@ad.jcorp" `
        -Path "OU=$($person.Service),$usersPath" `
        -AccountPassword $password -Enabled $true
    Add-ADGroupMember -Identity "GG_$($person.Service)" -Members $person.Sam
    if ($person.Role) {
        Add-ADGroupMember -Identity $person.Role -Members $person.Sam
    }
}

$groupsCount = @(Get-ADGroup -Filter * -SearchBase $groupsPath -SearchScope OneLevel).Count
$usersCount = @(Get-ADUser -Filter * -SearchBase $usersPath -SearchScope Subtree).Count
Write-Host "Termine : $groupsCount groupes et $usersCount comptes nominatifs." -ForegroundColor Green
if ($groupsCount -ne 17 -or $usersCount -ne 42) {
    throw 'Les totaux ne correspondent pas aux 17 groupes et 42 comptes attendus.'
}

