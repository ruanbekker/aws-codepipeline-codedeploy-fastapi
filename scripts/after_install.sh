#!/usr/bin/env bash
# CodeDeploy deploys the release at /home/snake/_target
# but I wanted to store the releases in timestamp formats
set -ex
APP_USER=snake
APP_GROUP=snake
DATESTAMP="$(date +%F)"
CD_INSTALL_TARGET=/home/snake/_target

function systemd_unit_file_check() {
  echo "copying systemd unit file in place"
  sudo cp "${CD_INSTALL_TARGET}/configs/python-app.service" /etc/systemd/system/python-app.service
  sudo systemctl daemon-reload
}

function update_deployment_envvar() {
  PREVIOUS_DEPLOYMENT_ID=$(cat /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/.version)
  sudo cp /home/snake/_target/configs/sample.env /home/snake/_target/.env
  sudo sed -i "s/__PREVIOUS_DEPLOYMENT_ID__/${PREVIOUS_DEPLOYMENT_ID}/g" /home/snake/_target/.env
  sudo sed -i "s/__CURRENT_DEPLOYMENT_ID__/${DEPLOYMENT_ID}/g" /home/snake/_target/.env
}

function install_dependencies(){
  sudo python3 -m pip install -r /home/${APP_USER}/app/current/dependencies/requirements.pip
}

function set_permissions() {
  sudo chown -R ${APP_USER}:${APP_GROUP} /home/${APP_USER}/
}

function log_status(){
  echo "[${DATESTAMP}] after install step completed"
}

# copy systemd unit file if not in place
systemd_unit_file_check

# update env vars file
update_deployment_envvar

# install the dependencies
install_dependencies

# set permissions
set_permissions

# log status
log_status
