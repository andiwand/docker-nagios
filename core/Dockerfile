FROM ubuntu:16.04

ARG CORE_GIT="https://github.com/NagiosEnterprises/nagioscore.git"
ARG PLUGINS_GIT="https://github.com/nagios-plugins/nagios-plugins.git"
ARG NRPE_GIT="https://github.com/NagiosEnterprises/nrpe.git"
ARG CORE_TAG="nagios-4.3.4"
ARG PLUGINS_TAG="release-2.2.1"
ARG NRPE_TAG="nrpe-3.2.1"
ARG NAGIOS_HOME="/usr/local/nagios"
ARG SOURCE_PATH="/usr/src"

ENV CORE_SOURCE_PATH="${SOURCE_PATH}/nagioscore" \
    PLUGINS_SOURCE_PATH="${SOURCE_PATH}/nagios-plugins" \
    NRPE_SOURCE_PATH="${SOURCE_PATH}/nrpe" \
    \
    NAGIOS_BIN="${NAGIOS_HOME}/bin" \
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

#RUN groupadd -r nagcmd \
#    && useradd -r -G nagcmd -d "${NAGIOS_HOME}" -s "/bin/bash" nagios

RUN git clone "${CORE_GIT}" "${CORE_SOURCE_PATH}"
RUN cd "${CORE_SOURCE_PATH}" \
    && git fetch \
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
    && make install-config
RUN rm -rf "${CORE_SOURCE_PATH}"

RUN git clone "${PLUGINS_GIT}" "${PLUGINS_SOURCE_PATH}"
RUN cd "${PLUGINS_SOURCE_PATH}" \
    && git fetch \
    && git checkout "${PLUGINS_TAG}" \
    && ./tools/setup \
    && ./configure --prefix="${NAGIOS_HOME}" --with-cgiurl="/nagios/cgi-bin" \
    && make \
    && make install
RUN rm -rf "${PLUGINS_SOURCE_PATH}"

RUN git clone "${NRPE_GIT}" "${NRPE_SOURCE_PATH}"
RUN cd "${NRPE_SOURCE_PATH}" \
    && git fetch \
    && git checkout "${NRPE_TAG}" \
    && ./configure \
    && make check_nrpe \
    && cp "src/check_nrpe" "${NAGIOS_HOME}/libexec/"
RUN rm -rf "${NRPE_SOURCE_PATH}"

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

RUN mkdir "${NAGIOS_VAR}/rw"

VOLUME "${NAGIOS_ETC}"

CMD "${NAGIOS_BIN}/nagios" "${NAGIOS_ETC}/nagios.cfg"

