#!/bin/bash

if [ -f /cron/crons.conf ]
then
    rm /root/crons.conf
    cp /cron/crons.conf /root/crons.conf
else
    cp /root/crons.conf /cron/crons.conf
fi

crontab /root/crons.conf

if [ ! -f /root/.gnupg/pubring.gpg ]
then
	#Generate GPG keys
	echo "Generate GPG keys"
	duply-runner gen-key
fi

IFS=':' read -a profilesarray <<< "$PROFILES"
for profile in "${profilesarray[@]}"; do
	if [ ! -d /root/.duply/$profile ]
        then
		duply-runner $profile create
		echo "Created profile for $profile."
	fi
done
env > /root/env.txt
