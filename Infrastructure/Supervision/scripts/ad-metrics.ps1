# ad-metrics.ps1 - Exporte l'etat de l'annuaire au format Prometheus (collecteur textfile de windows_exporter)
# Execute toutes les 5 minutes par une tache planifiee, compte SYSTEM, sur JCORP-DC01.
Import-Module ActiveDirectory

$dossier = "C:\Program Files\windows_exporter\textfile_inputs"
$cible   = Join-Path $dossier "ad.prom"
$tmp     = Join-Path $dossier "ad.prom.tmp"

$users     = Get-ADUser -Filter * -Properties Enabled, LockedOut, PasswordExpired, LastLogonDate
$computers = Get-ADComputer -Filter * -Properties Enabled
$groups    = Get-ADGroup -Filter *
$ous       = Get-ADOrganizationalUnit -Filter *
$admins    = Get-ADGroupMember -Identity "Admins du domaine" -Recursive -ErrorAction SilentlyContinue
if (-not $admins) { $admins = Get-ADGroupMember -Identity "Domain Admins" -Recursive -ErrorAction SilentlyContinue }
$seuil     = (Get-Date).AddDays(-30)

$m = @(
  "# HELP jcorp_ad_users Comptes utilisateurs par etat",
  "# TYPE jcorp_ad_users gauge",
  "jcorp_ad_users{state=`"total`"} $(@($users).Count)",
  "jcorp_ad_users{state=`"enabled`"} $(@($users | Where-Object Enabled).Count)",
  "jcorp_ad_users{state=`"disabled`"} $(@($users | Where-Object { -not $_.Enabled }).Count)",
  "jcorp_ad_users{state=`"locked`"} $(@($users | Where-Object LockedOut).Count)",
  "jcorp_ad_users{state=`"password_expired`"} $(@($users | Where-Object PasswordExpired).Count)",
  "jcorp_ad_users{state=`"inactive_30d`"} $(@($users | Where-Object { $_.Enabled -and $_.LastLogonDate -lt $seuil }).Count)",
  "# HELP jcorp_ad_computers Comptes ordinateurs par etat",
  "# TYPE jcorp_ad_computers gauge",
  "jcorp_ad_computers{state=`"total`"} $(@($computers).Count)",
  "jcorp_ad_computers{state=`"enabled`"} $(@($computers | Where-Object Enabled).Count)",
  "# HELP jcorp_ad_groups Nombre de groupes",
  "# TYPE jcorp_ad_groups gauge",
  "jcorp_ad_groups $(@($groups).Count)",
  "# HELP jcorp_ad_ous Nombre d'unites d'organisation",
  "# TYPE jcorp_ad_ous gauge",
  "jcorp_ad_ous $(@($ous).Count)",
  "# HELP jcorp_ad_domain_admins Membres effectifs du groupe Admins du domaine",
  "# TYPE jcorp_ad_domain_admins gauge",
  "jcorp_ad_domain_admins $(@($admins).Count)",
  "# HELP jcorp_ad_script_last_run_timestamp_seconds Derniere execution reussie du script",
  "# TYPE jcorp_ad_script_last_run_timestamp_seconds gauge",
  "jcorp_ad_script_last_run_timestamp_seconds $([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"
)

# UTF-8 sans BOM, fins de ligne LF, ecriture atomique pour ne jamais exposer un fichier a moitie ecrit
[IO.File]::WriteAllText($tmp, (($m -join "`n") + "`n"), (New-Object Text.UTF8Encoding($false)))
Move-Item -Path $tmp -Destination $cible -Force
