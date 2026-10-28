# renovate-regex: datasource=docker packageName=ghcr.io/mihaiush/xvfb
ARG IMAGE_VERSION="21.1.25-2-31"
FROM ghcr.io/mihaiush/xvfb:${IMAGE_VERSION}

RUN \
    echo 'APT::Install-Recommends "false";' >>/etc/apt/apt.conf &&\
    echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get -q -y update &&\
    apt-get -q -y dist-upgrade --auto-remove

RUN \
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get -q -y install \
        curl gpg 

RUN \
    curl -L https://apt.insync.io/insynchq.gpg 2>/dev/null | gpg --dearmor >/etc/apt/trusted.gpg.d/insynchq.gpg

# renovate-regex: datasource=custom.version packageName=insync,testing
ENV INSYNC_VERSION="3.9.11.60043"
RUN \
    . /etc/os-release &&\
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/insynchq.gpg] http://apt.insync.io/${ID} ${VERSION_CODENAME} non-free contrib" >/etc/apt/sources.list.d/insync.list &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get -q -y update &&\
    apt-get -q -y install \
        insync=${INSYNC_VERSION}-${VERSION_CODENAME} \
        lsb-release bsdextrautils procps shared-mime-info \
        libasound2t64 libxcb-shape0

COPY insync-run /usr/local/bin/

VOLUME /xvfb
CMD insync-run
