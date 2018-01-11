#!/bin/bash

set -xe

NAGIOS_UID=${NAGIOS_USER_ID:-9001}
NAGIOS_GID=${NAGIOS_GROUP_ID:-9001}
NAGCMD_GID=${NAGCMD_GROUP_ID:-9002}

usermod -u "${NAGIOS_UID}" nagios
groupmod -u "${NAGIOS_GID}" nagios
groupmod -u "${NAGCMD_GID}" nagcmd

chown -R nagios:nagios "${NAGIOS_ETC}"
chown -R nagios:nagios "${NAGIOS_VAR}"
chown -R nagios:nagcmd "${NAGIOS_VAR}/rw"
chmod g+s "${NAGIOS_VAR}/rw"

nagios "$@"

