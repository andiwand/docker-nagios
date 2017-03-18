#!/bin/bash

set -xe

NAGIOS_UID=${NAGIOS_USER_ID:-9001}
NAGCMD_GID=${NAGCMD_GROUP_ID:-9002}

userdel nagios
groupdel nagcmd
groupadd -r -g "${NAGCMD_GID}" nagcmd
useradd -r -u "${USER_ID}" -G nagcmd -d "${NAGIOS_HOME}" -s "/bin/bash" nagios

# TODO: fix permissions only once
chown nagios:nagios -R "${NAGIOS_ETC}"
chown nagios:nagios -R "${NAGIOS_VAR}"
chown nagios:nagcmd "${NAGIOS_VAR}/rw"
chmod g+s "${NAGIOS_VAR}/rw"

exec /usr/local/bin/gosu nagios "$@"
