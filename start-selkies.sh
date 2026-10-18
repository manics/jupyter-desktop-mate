#!/bin/sh
set -eu

export HOME=${HOME:-/home/jovyan}

# Checks if PASSWORD is unset
if [ -z "${PASSWORD+x}" ]; then
  echo "PASSWORD must be explicitly set to empty string to disable authentication"
  exit 1
fi

if [ ! -d "${HOME}/Desktop" ]; then
  echo "First run, setting up HOME"
  rsync -a --ignore-existing "$HOME_TEMPLATE_DIR/" "${HOME}/"
fi

if [ -z "$PASSWORD" ]; then
  AUTH_ARGS="--enable-basic-auth=false"
else
  AUTH_ARGS="--enable-basic-auth=true --basic-auth-user=jovyan --basic-auth-password=$PASSWORD"
fi

unset PASSWORD

exec selkies-session --port=8080 --addr=0.0.0.0 $AUTH_ARGS "$@"
