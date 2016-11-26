FROM ubuntu:16.04

ARG NAGIOS_CORE_TAG="tags/nagios-4.2.2"
ARG NAGIOS_PLUGINS_TAG="tags/release-2.1.3"
ARG NRPE_TAG="tags/3.0.1"

ARG NAGIOS_HOME="/usr/local/nagios"

ENV NAGIOS_HOME="${NAGIOS_HOME}" \
    NAGIOS_CONFIG="${NAGIOS_HOME}/etc" \
    USER_ID="9000" \
    GROUP_ID="9000" \
    CMDGROUP_ID="9001"

RUN apt-get update \
    && apt-get install -y \
        build-essential             \
        automake                    \
        autoconf                    \
        gettext                     \
        git                         \
                                    \
        libfreeradius-client-dev    \
        libgd2-xpm-dev              \
        libssl-dev                  \
                                    \
        sudo                        \
                                    \
        ssmtp                       \
                                    \
        fping                       \
        parallel                    \
        iputils-ping                \
        netcat                      \
        m4                          \
        gperf                       \
        snmp                        \
        runit                       \
        unzip                       \
        bc

RUN useradd -r -d "${NAGIOS_HOME}" nagios \
    && groupadd -r nagcmd \
    && usermod -a -G nagcmd nagios

RUN git clone "https://github.com/NagiosEnterprises/nagioscore.git" "/tmp/nagioscore" \
    && cd "/tmp/nagioscore" \
    && git checkout "${NAGIOS_CORE_TAG}" \
    && ./configure \
        --prefix="${NAGIOS_HOME}" \
        --exec-prefix="${NAGIOS_HOME}" \
        --enable-event-broker \
        --with-nagios-command-user=nagios \
        --with-command-group=nagcmd \
        --with-nagios-user=nagios \
        --with-nagios-group=nagios \
    && make all

RUN git clone "https://github.com/nagios-plugins/nagios-plugins.git" "/tmp/nagios-plugins" \
    && cd "/tmp/nagios-plugins" \
    && git checkout "${NAGIOS_PLUGINS_TAG}" \
    && ./tools/setup \
    && ./configure --prefix="${NAGIOS_HOME}" \
    && make

RUN git clone "https://github.com/NagiosEnterprises/nrpe.git" "/tmp/nrpe" \
    && cd "/tmp/nrpe" \
    && git checkout "${NRPE_TAG}" \
    && ./configure \
        --with-ssl="/usr/bin/openssl" \
        --with-ssl-lib="/usr/lib/x86_64-linux-gnu" \
    && make check_nrpe

RUN cd "/tmp/nagioscore" \
    && make install \
    && make install-config \
    && make install-commandmode

RUN cd "/tmp/nagios-plugins" \
    && make install \
    && mkdir -p "/usr/lib/nagios/plugins" \
    && ln -sf "${NAGIOS_HOME}/libexec/utils.pm" "/usr/lib/nagios/plugins"

RUN cd "/tmp/nrpe" \
    && cp "src/check_nrpe" "${NAGIOS_HOME}/libexec/"

RUN apt-get remove -y \
        build-essential             \
        automake                    \
        autoconf                    \
        gettext                     \
        git                         \
                                    \
        libfreeradius-client-dev    \
        libgd2-xpm-dev              \
        libssl-dev                  \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

ADD "entrypoint.sh" "/usr/local/share/docker-nagios-core/entrypoint.sh"

VOLUME [ "${NAGIOS_CONFIG}", "/etc/ssmtp" ]

ENTRYPOINT "/usr/local/share/docker-nagios-core/entrypoint.sh"
