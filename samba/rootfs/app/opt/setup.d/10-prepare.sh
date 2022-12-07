#!/usr/bin/env bash
source $SETUP_BASE_DIR/_common.sh

[[ -e /var/run/dbus.pid ]] && rm -f /var/run/dbus.pid
[[ -e /var/run/dbus/pid ]] && rm -f /var/run/dbus/pid
[[ -e /run/dbus/dbus.pid ]] && rm -f /run/dbus/dbus.pid
[[ -e /var/run/avahi-daemon/pid ]] && rm -f /var/run/avahi-daemon/pid
