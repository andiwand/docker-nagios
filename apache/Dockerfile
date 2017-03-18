FROM php:7.0-apache

ARG NAGIOS_HOME

ENV NAGIOS_HOME="${NAGIOS_HOME:-/usr/local/nagios}" \
	APACHE_CONF="${NAGIOS_HOME}/apache"

RUN set -x \
    && a2enmod rewrite cgi \
    && mkdir -p "${NAGIOS_HOME}" \
    && mkdir -p "${APACHE_CONF}" \
    && htpasswd -b -c "${APACHE_CONF}/htpasswd.user" nagiosadmin nagios \
    && ln -s "${APACHE_CONF}/apache.conf" "/etc/apache2/sites-enabled/000-nagios.conf"

ADD "entrypoint.sh" "/usr/local/bin/entrypoint.sh"
ADD "apache.conf" "${APACHE_CONF}/apache.conf"

VOLUME [ "${APACHE_CONF}" ]

ENTRYPOINT "/usr/local/bin/entrypoint.sh"
