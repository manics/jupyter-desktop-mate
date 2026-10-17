#!/bin/sh

# If Firefox sandboxing doesn't work then see
# https://wiki.mozilla.org/Security/Sandbox#Environment_variables

rsync -a --ignore-existing "$HOME_TEMPLATE_DIR/" /home/jovyan/

exec dbus-launch mate-session "$@"
