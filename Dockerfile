FROM ubuntu:16.04

MAINTAINER JiangWeiGitHub <wei.jiang@winsuntech.cn>

# update apt
# DNS problem, turn ubuntu.uestc.edu.cn to 202.115.22.208
RUN echo "deb http://202.115.22.208/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://202.115.22.208/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list \
  && echo "deb http://202.115.22.208/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
  && echo "deb http://202.115.22.208/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list \
  && echo "deb http://202.115.22.208/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get -y upgrade

# install essential packages with apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  autoconf \
  automake \
  autotools-dev \
  build-essential \
  cdbs \
  d-shlibs \
  debhelper \
  dh-buildinfo \
  dh-systemd \
  devscripts \
  libacl1-dev \  
  libavahi-client-dev \
  libcups2-dev \
  libevent-dev \
  libssl-dev \
  libgcrypt11-dev \
  libltdl3-dev \
  libkrb5-dev \
  libpam0g-dev \
  libwrap0-dev \
  libdb-dev \
  libmysqlclient-dev \
  libldap2-dev \
  libcrack2-dev \
  libdbus-1-dev \
  libdbus-glib-1-dev \
  libglib2.0-dev \
  libtool \
  libtracker-miner-1.0-dev \
  libtracker-sparql-1.0-dev \
  systemtap-sdt-dev \
  tracker

RUN mkdir /download/ \
  && cd /download/

WORKDIR /download/

COPY netatalk-3.1.10.tar.bz2 /download/

# install netatalk 3.1.10
RUN tar jxf netatalk-3.1.10.tar.bz2 \
  && cd ./netatalk-3.1.10 \
  && ./configure \
    --with-init-style=debian-sysv \
    --without-libevent \
    --with-cracklib \
    --enable-krbV-uam \
    --with-pam-confdir=/etc/pam.d \
    --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
    --with-tracker-pkgconfig-version=1.0 \
  && make \
  && make install

# add user
RUN useradd -ms /bin/bash timemachine \
  && echo "timemachine:123456" | chpasswd \
  && mkdir -p /data/timemachine \
  && chown -R timemachine:timemachine /data/timemachine \
  && echo "[TimeMachine]" > /usr/local/etc/afp.conf \
  && echo "time machine = yes" >> /usr/local/etc/afp.conf \
  && echo "path = /data/timemachine" >> /usr/local/etc/afp.conf \
  && echo "vol size limit = 1000000" >> /usr/local/etc/afp.conf \
  && echo "valid users = timemachine" >> /usr/local/etc/afp.conf

# install others
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  libc6-dev \
  libnss-mdns \
  && apt-get clean
  
EXPOSE 548 636

VOLUME ["/data/timemachine"]

CMD ["pwd"]