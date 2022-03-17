#!/usr/bin/env bash
DATESTAMP="$(date +%FT%H:%m)"

if [ -f "/etc/systemd/system/python-app.service" ]
then
  sudo systemctl stop python-app
  sleep 1
  while [ "$(sudo systemctl is-active python-app)" == "active" ] 
  do
    sleep 1
  done
  echo "[${DATESTAMP}] application stopped"
fi

