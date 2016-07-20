FROM phusion/baseimage:0.9.17

MAINTAINER David Falk

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	wget \
    duply \
    ncftp \
    python-boto \
#	python-pip \
    pwgen \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
	
RUN apt-get remove -y --no-install-recommends \
    duplicity \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
	
#RUN       pip install paramiko

RUN       wget https://code.launchpad.net/duplicity/0.7-series/0.7.05/+download/duplicity-0.7.05.tar.gz && \
          tar xzvf duplicity*

RUN	  cd duplicity* && \
	  python setup.py install

VOLUME /root/
VOLUME /backup/

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

ADD setup.sh /etc/my_init.d/setup.sh
#RUN chmod a+x /etc/my_init.d/setup.sh

# Add our crontab file
ADD crons.conf /root/crons.conf

# Use the crontab file
#RUN crontab /root/crons.conf

# Start cron
RUN cron
