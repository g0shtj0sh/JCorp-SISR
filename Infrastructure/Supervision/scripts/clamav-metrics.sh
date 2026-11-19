#!/bin/bash
# clamav-metrics.sh - Exporte l'etat de ClamAV au format Prometheus (collecteur textfile de node_exporter)
# Execute toutes les 5 minutes par clamav-metrics.timer, en root, sur User2-JCorp (VM 702).
set -u

DIR=/var/lib/prometheus/node-exporter
OUT="$DIR/clamav.prom"
TMP="$OUT.$$"
LOG=/var/log/clamav/scan-home-hebdo.log
QUAR=/var/quarantine

actif() { systemctl is-active --quiet "$1" && echo 1 || echo 0; }

# Version moteur, version et date de la base daily (ex. "ClamAV 1.4.3/28188/Thu Nov 19 07:24:39 2026")
VER=$(clamdscan --version 2>/dev/null || clamscan --version)
ENGINE=$(echo "$VER" | cut -d/ -f1 | awk '{print $2}')
DAILY=$(echo "$VER" | cut -d/ -f2)
DBDATE=$(date -d "$(echo "$VER" | cut -d/ -f3-)" +%s 2>/dev/null || echo 0)

# Dernier bloc "SCAN SUMMARY" du rapport de l'analyse hebdomadaire
BLOC=$(awk '/SCAN SUMMARY/{b=""} {b=b $0 "\n"} END{printf "%s", b}' "$LOG" 2>/dev/null)
val() { local v; v=$(echo "$BLOC" | grep -m1 "^$1:" | cut -d: -f2- | awk '{print $1}'); echo "${v:-0}"; }
date_scan() { local d; d=$(echo "$BLOC" | grep -m1 "^$1:" | cut -d: -f2- | sed 's/^ *//; s/:/-/; s/:/-/'); date -d "$d" +%s 2>/dev/null || echo 0; }
octets() {
  local l n u; l=$(echo "$BLOC" | grep -m1 "^Data scanned:"); n=$(echo "$l" | awk '{print $3}'); u=$(echo "$l" | awk '{print $4}')
  case "$u" in KB) m=1024;; MB) m=1048576;; GB) m=1073741824;; *) m=1;; esac
  awk -v n="${n:-0}" -v m="$m" 'BEGIN{printf "%.0f", n*m}'
}

NEXT=$(systemctl show scan-home-hebdo.timer -p NextElapseUSecRealtime --value 2>/dev/null)
NEXT=$(date -d "$NEXT" +%s 2>/dev/null || echo 0)
NQUAR=$(find "$QUAR" -type f 2>/dev/null | wc -l)

cat > "$TMP" <<EOF
# HELP clamav_service_up Service ClamAV actif (1) ou non (0)
# TYPE clamav_service_up gauge
clamav_service_up{service="clamav-daemon"} $(actif clamav-daemon)
clamav_service_up{service="clamav-freshclam"} $(actif clamav-freshclam)
clamav_service_up{service="clamonacc"} $(actif clamonacc)
# HELP clamav_engine_info Version du moteur ClamAV
# TYPE clamav_engine_info gauge
clamav_engine_info{version="${ENGINE:-inconnue}"} 1
# HELP clamav_database_daily_version Version de la base de signatures daily
# TYPE clamav_database_daily_version gauge
clamav_database_daily_version ${DAILY:-0}
# HELP clamav_database_timestamp_seconds Date de publication de la base daily chargee
# TYPE clamav_database_timestamp_seconds gauge
clamav_database_timestamp_seconds $DBDATE
# HELP clamav_known_signatures Signatures connues lors de la derniere analyse
# TYPE clamav_known_signatures gauge
clamav_known_signatures $(val "Known viruses")
# HELP clamav_last_scan_end_timestamp_seconds Fin de la derniere analyse hebdomadaire
# TYPE clamav_last_scan_end_timestamp_seconds gauge
clamav_last_scan_end_timestamp_seconds $(date_scan "End Date")
# HELP clamav_last_scan_duration_seconds Duree de la derniere analyse
# TYPE clamav_last_scan_duration_seconds gauge
clamav_last_scan_duration_seconds $(val "Time")
# HELP clamav_last_scan_files Fichiers et dossiers examines lors de la derniere analyse
# TYPE clamav_last_scan_files gauge
clamav_last_scan_files{type="files"} $(val "Scanned files")
clamav_last_scan_files{type="directories"} $(val "Scanned directories")
clamav_last_scan_files{type="infected"} $(val "Infected files")
# HELP clamav_last_scan_data_bytes Volume analyse lors de la derniere analyse
# TYPE clamav_last_scan_data_bytes gauge
clamav_last_scan_data_bytes $(octets)
# HELP clamav_next_scan_timestamp_seconds Prochaine analyse programmee
# TYPE clamav_next_scan_timestamp_seconds gauge
clamav_next_scan_timestamp_seconds $NEXT
# HELP clamav_quarantine_files Fichiers presents en quarantaine
# TYPE clamav_quarantine_files gauge
clamav_quarantine_files $NQUAR
EOF

chmod 644 "$TMP" && mv "$TMP" "$OUT"
