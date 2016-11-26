#!/bin/bash

set -x

OLD_USER_ID=$(id -u nagios)
OLD_GROUP_ID=$(id -g nagios)
OLD_CMDGROUP_ID=$(id -g nagcmd)

if [ "${USER_ID}" -ne "${OLD_USER_ID}" ]; then
    usermod -u ${USER_ID} nagios
    find / -user ${OLD_USER_ID} -exec chown -h ${USER_ID} {} \;
fi
if [ "${GROUP_ID}" -ne "${OLD_GROUP_ID}" ]; then
    groupmod -g ${GROUP_ID} nagios
    usermod -g ${GROUP_ID} nagios
    find / -group ${OLD_GROUP_ID} -exec chgrp -h ${GROUP_ID} {} \;
fi
if [ "${CMDGROUP_ID}" -ne "${OLD_CMDGROUP_ID}" ]; then
    groupmod -g ${CMDGROUP_ID} nagcmd
    find / -group ${OLD_CMDGROUP_ID} -exec chgrp -h ${CMDGROUP_ID} {} \;
fi

sudo -H -u nagios "${NAGIOS_HOME}/bin/nagios" "${NAGIOS_HOME}/etc/nagios.cfg"
