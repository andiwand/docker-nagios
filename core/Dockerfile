FROM ubuntu:16.04

ARG CORE_GIT="https://github.com/NagiosEnterprises/nagioscore.git"
ARG PLUGINS_GIT="https://github.com/nagios-plugins/nagios-plugins.git"
ARG NRPE_GIT="https://github.com/NagiosEnterprises/nrpe.git"
ARG CORE_TAG="nagios-4.3.4"
ARG PLUGINS_TAG="release-2.2.1"
ARG NRPE_TAG="nrpe-3.2.1"
ARG HOME_PATH="/nagios"
ARG SOURCE_PATH="/usr/src"

RUN apt-get update
RUN apt-get install -y \
        build-essential \
        automake \
        autoconf \
        gettext \
        unzip \
        git \
        wget \
        openssl \
        ca-certificates
RUN apt-get install -y \
        libfreeradius-client-dev \
        libgd2-xpm-dev \
        libssl-dev
RUN apt-get install -y \
        fping \
        parallel \
        iputils-ping \
        netcat \
        m4 \
        gperf \
        snmp \
        runit \
        bc

#RUN groupadd -r nagcmd \
#    && useradd -r -G nagcmd -d "${HOME_PATH}" -s "/bin/bash" nagios

RUN git clone "${CORE_GIT}" "${SOURCE_PATH}/nagioscore"
RUN cd "${SOURCE_PATH}/nagioscore" \
    && git fetch \
    && git checkout "${CORE_TAG}" \
    && ./configure \
        --prefix="${HOME_PATH}" \
        --exec-prefix="${HOME_PATH}" \
        --enable-event-broker \
        --with-nagios-user=root \
        --with-nagios-group=root \
        --with-nagios-command-user=root \
        --with-command-group=root \
    && CPU_CORES="$(grep -c processor /proc/cpuinfo)" || CPU_CORES="4" \
    && make -j "${CPU_CORES}" all \
    && make install \
    && make install-config
RUN rm -rf "${SOURCE_PATH}/nagioscore"

RUN git clone "${PLUGINS_GIT}" "${SOURCE_PATH}/nagios-plugins"
RUN cd "${SOURCE_PATH}/nagios-plugins" \
    && git fetch \
    && git checkout "${PLUGINS_TAG}" \
    && ./tools/setup \
    && ./configure --prefix="${HOME_PATH}" --with-cgiurl="/nagios/cgi-bin" \
    && CPU_CORES="$(grep -c processor /proc/cpuinfo)" || CPU_CORES="4" \
    && make -j "${CPU_CORES}" \
    && make install
RUN rm -rf "${SOURCE_PATH}/nagios-plugins"

RUN git clone "${NRPE_GIT}" "${SOURCE_PATH}/nrpe"
RUN cd "${SOURCE_PATH}/nrpe" \
    && git fetch \
    && git checkout "${NRPE_TAG}" \
    && ./configure \
    && CPU_CORES="$(grep -c processor /proc/cpuinfo)" || CPU_CORES="4" \
    && make -j "${CPU_CORES} check_nrpe \
    && cp "src/check_nrpe" "${HOME_PATH}/libexec/"
RUN rm -rf "${SOURCE_PATH}/nrpe"

RUN apt-get remove -y \
        build-essential \
        automake \
        autoconf \
        gettext \
        unzip \
        git \
        wget \
        ca-certificates \
    && apt-get remove -y \
        libfreeradius-client-dev \
        libgd2-xpm-dev \
        libssl-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf "/var/lib/apt/lists/*"

VOLUME "${HOME_PATH}/etc"

ENV HOME_PATH="${HOME_PATH}"

CMD "${HOME_PATH}/bin/nagios" "${HOME_PATH}/etc/nagios.cfg"

