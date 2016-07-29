#!/bin/bash
PATH="$PATH:/usr/local/bin"
script -f -c 'duply-runner default backup_verify_purge --force' /root/.duply/log.txt

