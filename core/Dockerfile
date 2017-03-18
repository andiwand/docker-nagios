FROM ubuntu:16.04

ARG CORE_GIT
ARG PLUGINS_GIT
ARG NRPE_GIT
ARG CORE_TAG
ARG PLUGINS_TAG
ARG NRPE_TAG
ARG NAGIOS_HOME
ARG GOSU_VERSION
ARG GOSU_URL
ARG GOSU_PGP_KEY

ENV CORE_GIT="${CORE_GIT:-https://github.com/NagiosEnterprises/nagioscore.git}" \
    PLUGINS_GIT="${PLUGINS_GIT:-https://github.com/nagios-plugins/nagios-plugins.git}" \
    NRPE_GIT="${CORE_GIT:-https://github.com/NagiosEnterprises/nrpe.git}" \
    CORE_TAG="${CORE_TAG:-master}" \
    PLUGINS_TAG="${PLUGINS_TAG:-master}" \
    NRPE_TAG="${NRPE_TAG:-master}" \
    \
	SOURCE_PATH="/usr/src" \
    CORE_SOURCE_PATH="${SOURCE_PATH}/nagioscore" \
    PLUGINS_SOURCE_PATH="${SOURCE_PATH}/nagios-plugins" \
    NRPE_SOURCE_PATH="${SOURCE_PATH}/nrpe" \
    \
	NAGIOS_HOME="${NAGIOS_HOME:-/usr/local/nagios}" \
	NAGIOS_ETC="${NAGIOS_HOME}/etc" \
	NAGIOS_VAR="${NAGIOS_HOME}/var" \
    \
    GOSU_VERSION="${GOSU_VERSION:-1.7}" \
    GOSU_PGP_KEY="${GOSU_PGP_KEY:-B42F6819007F00F88E364FD4036A9C25BF357DD4}"
ENV GOSU_URL="${GOSU_URL:-https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}}"

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
	    build-essential             \
        automake                    \
        autoconf                    \
        gettext                     \
        unzip                       \
        git                         \
                                    \
        libfreeradius-client-dev    \
        libgd2-xpm-dev              \
        libssl-dev                  \
                                    \
		ca-certificates				\
		wget						\
									\
		ssmtp						\
									\
		fping						\
		parallel					\
		iputils-ping				\
		netcat						\
		m4							\
		gperf						\
		snmp						\
		runit						\
		bc                          \
	\
	&& wget -O /usr/local/bin/gosu "${GOSU_URL}/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "${GOSU_URL}/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${GOSU_PGP_KEY}" \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	\
	&& git clone "${CORE_GIT}" "${CORE_SOURCE_PATH}" \
    && cd "${CORE_SOURCE_PATH}" \
    && git checkout "${CORE_TAG}" \
    && ./configure \
        --prefix="${NAGIOS_HOME}" \
        --exec-prefix="${NAGIOS_HOME}" \
        --enable-event-broker \
        --with-nagios-user=root \
        --with-nagios-group=root \
        --with-nagios-command-user=root \
        --with-command-group=root \
    && make all \
    && make install \
    && make install-config \
	\
    && git clone "${PLUGINS_GIT}" "${PLUGINS_SOURCE_PATH}" \
    && cd "${PLUGINS_SOURCE_PATH}" \
    && git checkout "${PLUGINS_TAG}" \
    && ./tools/setup \
    && ./configure --prefix="${NAGIOS_HOME}" --with-cgiurl="/nagios/cgi-bin" \
    && make \
    && make install \
	\
    && git clone "${NRPE_GIT}" "${NRPE_SOURCE_PATH}" \
    && cd "${NRPE_SOURCE_PATH}" \
    && git checkout "${NRPE_TAG}" \
    && ./configure \
    && make check_nrpe \
    && cp "src/check_nrpe" "${NAGIOS_HOME}/libexec/" \
	\
	&& apt-get remove -y \
	    build-essential             \
        automake                    \
        autoconf                    \
        gettext                     \
        unzip                       \
        git                         \
                                    \
        libfreeradius-client-dev    \
        libgd2-xpm-dev              \
        libssl-dev                  \
                                    \
		ca-certificates				\
		wget						\
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

ADD "entrypoint.sh" "/usr/local/bin/entrypoint.sh"

VOLUME [ "${NAGIOS_ETC}", "${NAGIOS_VAR}", "/etc/ssmtp" ]

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "${NAGIOS_HOME}/bin/nagios", "${NAGIOS_HOME}/etc/nagios.cfg" ]
