FROM phusion/baseimage:0.9.17

MAINTAINER David Falk

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	wget \
    ncftp \
    python-boto \
    python3-pip \
    python-pycryptopp \
    python-setuptools \
    build-essential \
    python-lockfile \
    librsync-dev \
    python-dev \
    pwgen \
    git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN apt-get update && \
    apt-get install -y expect postfix && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
RUN       pip3 install --upgrade git+https://github.com/yadayada/acd_cli.git

RUN       wget https://code.launchpad.net/duplicity/0.7-series/0.7.08/+download/duplicity-0.7.08.tar.gz && \
          tar xzvf duplicity*

RUN	  cd duplicity* && \
	  python setup.py install

RUN       wget http://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/1.11.x/duply_1.11.3.tgz && \
          tar xzvf duply*

RUN       cd duply* && \
          cp duply /usr/local/bin/

VOLUME /root/.gnupg
VOLUME /root/.duply
VOLUME /backup/
VOLUME /cron
VOLUME /root/.cache/acd_cli

ENV HOME /root

ENV KEY_TYPE      RSA
ENV KEY_LENGTH    2048
ENV SUBKEY_TYPE   RSA
ENV SUBKEY_LENGTH 2048
ENV NAME_REAL     Duply Backup
ENV NAME_EMAIL    duply@localhost
ENV PASSPHRASE    random

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN mkfifo /var/spool/postfix/public/pickup

RUN mkdir /scripts

ADD setup.sh /etc/my_init.d/setup.sh
RUN chmod a+x /etc/my_init.d/setup.sh

ADD duply-runner.sh /usr/bin/duply-runner
RUN chmod a+x /usr/bin/duply-runner

ADD backup-runner.sh /usr/bin/backup-runner
RUN chmod a+x /usr/bin/backup-runner

# Add our crontab file
ADD crons.conf /root/crons.conf

# Use the crontab file
#RUN crontab /root/crons.conf

# Start cron
RUN cron

