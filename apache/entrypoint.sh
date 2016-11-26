#!/bin/bash

OLD_USER_ID=$(id -u www-data)
OLD_GROUP_ID=$(id -g www-data)

if [ "${USER_ID}" -ne "${OLD_USER_ID}" ]; then
    usermod -u ${USER_ID} www-data
    find / -user ${OLD_USER_ID} -exec chown -h ${USER_ID} {} \;
fi
if [ "${GROUP_ID}" -ne "${OLD_GROUP_ID}" ]; then
    groupmod -g ${GROUP_ID} www-data
    usermod -g ${GROUP_ID} www-data
    find / -group ${OLD_GROUP_ID} -exec chgrp -h ${GROUP_ID} {} \;
fi

apache2-foreground
