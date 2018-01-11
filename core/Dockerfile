FROM ubuntu:16.04

ARG CORE_GIT="https://github.com/NagiosEnterprises/nagioscore.git"
ARG PLUGINS_GIT="https://github.com/nagios-plugins/nagios-plugins.git"
ARG NRPE_GIT="https://github.com/NagiosEnterprises/nrpe.git"
ARG CORE_TAG="nagios-4.3.4"
ARG PLUGINS_TAG="release-2.2.1"
ARG NRPE_TAG="nrpe-3.2.1"
ARG NAGIOS_HOME="/usr/local/nagios"
ARG SOURCE_PATH="/usr/src"
ARG S6_OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.2/s6-overlay-amd64.tar.gz"

ENV CORE_SOURCE_PATH="${SOURCE_PATH}/nagioscore" \
    PLUGINS_SOURCE_PATH="${SOURCE_PATH}/nagios-plugins" \
    NRPE_SOURCE_PATH="${SOURCE_PATH}/nrpe" \
    \
	NAGIOS_ETC="${NAGIOS_HOME}/etc" \
	NAGIOS_VAR="${NAGIOS_HOME}/var"

RUN apt-get update
RUN apt-get install -y \
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
        openssl                     \
		ca-certificates				\
		wget						\
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
    && true

RUN groupadd -r nagcmd \
    && useradd -r -G nagcmd -d "${NAGIOS_HOME}" -s "/bin/bash" nagios

RUN git clone "${CORE_GIT}" "${CORE_SOURCE_PATH}"
RUN cd "${CORE_SOURCE_PATH}" \
    && git fetch \
    && git checkout "${CORE_TAG}" \
    && ./configure \
        --prefix="${NAGIOS_HOME}" \
        --exec-prefix="${NAGIOS_HOME}" \
        --enable-event-broker \
        --with-nagios-user=nagios \
        --with-nagios-group=nagios \
        --with-nagios-command-user=nagios \
        --with-command-group=nagcmd \
    && make all \
    && make install \
    && make install-config

RUN git clone "${PLUGINS_GIT}" "${PLUGINS_SOURCE_PATH}"
RUN cd "${PLUGINS_SOURCE_PATH}" \
    && git fetch \
    && git checkout "${PLUGINS_TAG}" \
    && ./tools/setup \
    && ./configure --prefix="${NAGIOS_HOME}" --with-cgiurl="/nagios/cgi-bin" \
    && make \
    && make install

RUN git clone "${NRPE_GIT}" "${NRPE_SOURCE_PATH}"
RUN cd "${NRPE_SOURCE_PATH}" \
    && git fetch \
    && git checkout "${NRPE_TAG}" \
    && ./configure \
    && make check_nrpe \
    && cp "src/check_nrpe" "${NAGIOS_HOME}/libexec/"

RUN apt-get remove -y \
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
	&& rm -rf "/var/lib/apt/lists/*"

ADD "${S6_OVERLAY_URL}" "/tmp/s6-overlay-amd64.tar.gz"
RUN tar -xzf "/tmp/s6-overlay-amd64.tar.gz" -C / \
    && rm "/tmp/s6-overlay-amd64.tar.gz"

COPY "root/" "/"

VOLUME [ "${NAGIOS_ETC}", "${NAGIOS_VAR}" ]

ENTRYPOINT [ "/init" ]

CMD [ "nagios", "${NAGIOS_HOME}/etc/nagios.cfg" ]

