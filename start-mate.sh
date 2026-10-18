#!/bin/sh

# Firefox sandboxing may not work in a container
# https://wiki.mozilla.org/Security/Sandbox#Environment_variables
export MOZ_DISABLE_CONTENT_SANDBOX=1
export MOZ_DISABLE_GMP_SANDBOX=1
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_DISABLE_SOCKET_PROCESS_SANDBOX=1

export HOME=${HOME:-/home/jovyan}

rsync -a --ignore-existing "$HOME_TEMPLATE_DIR/" "${HOME}/"

if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
  exec dbus-run-session -- mate-session "$@"
  # exec dbus-launch mate-session "$@"
else
  exec mate-session "$@"
fi
