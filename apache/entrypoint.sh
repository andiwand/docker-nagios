#!/bin/bash

set -xe

NAGCMD_GID=${NAGCMD_GROUP_ID:-9002}

groupdel nagcmd
groupadd -r -g "${NAGCMD_GID}" nagcmd
usermod -a -G nagcmd www-data

apache2-foreground
