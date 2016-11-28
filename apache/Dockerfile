FROM php:7.0-apache

ENV USER_ID="9002" \
    GROUP_ID="9002" \
    CMDGROUP_ID="9001"

COPY "entrypoint.sh" "/usr/local/share/docker-nagios-apache/entrypoint.sh"
COPY "apache.conf" "/usr/local/share/docker-nagios-apache/config/apache.conf"

RUN groupadd -r -g ${CMDGROUP_ID} nagcmd \
    && usermod -a -G nagcmd www-data \
    && a2enmod rewrite cgi \
    && htpasswd -b -c "/usr/local/share/docker-nagios-apache/config/htpasswd.user" nagiosadmin nagios \
    && ln -s "/usr/local/share/docker-nagios-apache/config/apache.conf" "/etc/apache2/sites-enabled/000-nagios.conf"

VOLUME "/usr/local/share/docker-nagios-apache/config"

ENTRYPOINT "/usr/local/share/docker-nagios-apache/entrypoint.sh"
