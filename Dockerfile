# renovate: datasource=docker depName=mihaiush/xvfb registryUlr=https://ghcr.io
ARG IMAGE_VERSION=21.1.24-1-8
FROM ghcr.io/mihaiush/xvfb:${IMAGE_VERSION}

# renovate: datasource=custom.html depName=dummy registryUrl=https://www.insynchq.com/downloads/linux
ENV INSYNC_VERSION=0.0.0

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

RUN \
    . /etc/os-release &&\
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/insynchq.gpg] http://apt.insync.io/${ID} ${VERSION_CODENAME} non-free contrib" >/etc/apt/sources.list.d/insync.list &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get -q -y update &&\
    apt-get -q -y install \
        insync lsb-release bsdextrautils procps shared-mime-info \
        libasound2t64 libxcb-shape0

ADD insync-run /usr/local/bin/

VOLUME /xvfb
CMD insync-run
