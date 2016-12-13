FROM ubuntu:16.04

MAINTAINER JiangWeiGitHub <wei.jiang@winsuntech.cn>

# update apt
RUN apt-get update

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

# install netatalk
RUN mkdir /download/ \
  && cd /download/ \
  && wget -O netatalk-3.1.10.tar.bz2 http://downloads.sourceforge.net/project/netatalk/netatalk/3.1.10/netatalk-3.1.10.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fnetatalk%2Ffiles%2F&ts=1481622866&use_mirror=jaist \
  && tar Jxf netatalk-3.1.10.tar.bz2 \
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
  && echo "123456" | passwd timemachine --stdin \
  && mkdir -p /data/timemachine \
  && chown -R timemachine:timemachine /data/timemachine \
  && echo "[TimeMachine]" > /usr/local/etc/afp.conf \
  && echo "time machine = yes" >> /usr/local/etc/afp.conf \
  && echo "path = /data/timemachine" >> /usr/local/etc/afp.conf \
  && echo "vol size limit = 1000000" >> /usr/local/etc/afp.conf \
  && echo "valid users = timemachine" >> /usr/local/etc/afp.conf

# install avahi
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  && avahi-daemon \
  && libc6-dev \
  && libnss-mdns

CMD ["systemctl start avahi-daemon.service && systemctl start netatalk.service"]
