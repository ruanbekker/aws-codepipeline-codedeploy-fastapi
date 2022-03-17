#!/usr/bin/env bash
set -ex

# global variables
APP_USER=snake
APP_GROUP=snake
DATESTAMP="$(date +%F)"
TIMESTAMP="$(date +%s)"

function detect_previous_package_dir(){
  DIRS_NUMBER="$(ls -latr /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/ | grep 'd-' | tail -n2 | wc -l)"
  if [ "${DIRS_NUMBER}" -lt 2 ]
  then 
    echo "Only current version detected, skipping"
  else
    PREV_DIR="$(ls -latr /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/ | grep 'd-' | tail -n2 | head -1 | rev | awk '{print $1}' | rev)"
    echo "previous directory: /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/${PREV_DIR}"
  fi
}

function debug_env(){
  echo "LIFECYCLE_EVENT=${LIFECYCLE_EVENT}" > /tmp/codedeploy.env
  echo "DEPLOYMENT_ID=${DEPLOYMENT_ID}" >> /tmp/codedeploy.env
  echo "APPLICATION_NAME=${APPLICATION_NAME}" >> /tmp/codedeploy.env
  echo "DEPLOYMENT_GROUP_NAME=${DEPLOYMENT_GROUP_NAME}" >> /tmp/codedeploy.env
  echo "DEPLOYMENT_GROUP_ID=${DEPLOYMENT_GROUP_ID}" >> /tmp/codedeploy.env
}

# functions
function user_and_group_check(){
  id -u ${APP_USER} &> /dev/null && EXIT_CODE=${?} || EXIT_CODE=${?}
  if [ ${EXIT_CODE} == 1 ]
    then
      sudo groupadd --gid 1002 ${APP_GROUP}
      sudo useradd --create-home --gid 1002 --shell /bin/bash ${APP_USER}
  fi
}

function log_status(){
  echo "[${DATESTAMP}] before install step completed"
}

function detect_environment(){
  if [ "$DEPLOYMENT_GROUP_NAME" == "devops-python-service-dg" ]
  then
    echo "Debug Environment"
  fi
}

# detect previous version
detect_previous_package_dir

# debug env vars for codedeploy
debug_env
# ensure the user exists
user_and_group_check

# log status
detect_environment
log_status
