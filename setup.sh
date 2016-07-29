#!/bin/bash

if [ -f /cron/crons.conf ]
then
    rm /root/crons.conf
    cp /cron/crons.conf /root/crons.conf
else
    cp /root/crons.conf /cron/crons.conf
    echo "Creating crons.conf with default values"
fi

if [ ! -f /root/.cache/acd_cli/oauth_data ]
then
    echo "Did not find oauth_data for acd_cli (Amazon Cloud Drive CLI)"
fi

acd_cli init

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
		duply-runner /root/.duply/$profile create
		echo "Created profile for $profile."
	fi
done

