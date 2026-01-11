#!/bin/sh
set -eu

# Checks if PASSWORD is unset
if [ -z "${PASSWORD+x}" ]; then
  echo "PASSWORD must be explicitly set to empty string to disable authentication"
  exit 1
fi

if [ ! -d /home/jovyan/Desktop ]; then
  echo "First run, setting up HOME"
  rsync -a --ignore-existing "$HOME_TEMPLATE_DIR/" /home/jovyan/
fi

VNC_PASSWD=/home/jovyan/.vnc/passwd

if [ -z "$PASSWORD" ]; then
  AUTH_ARGS="--I-KNOW-THIS-IS-INSECURE -SecurityTypes None"
else
  echo "$PASSWORD" | vncpasswd -f > "$VNC_PASSWD"
  AUTH_ARGS="-PasswordFile $VNC_PASSWD"
fi

unset PASSWORD

/usr/bin/tigervncserver :1 -fg -localhost no $AUTH_ARGS -xstartup /usr/local/bin/start-mate.sh
