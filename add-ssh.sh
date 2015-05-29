#!/bin/bash

mkdir -p /root/.ssh
ssh-keyscan -H  github.com >> /root/.ssh/known_hosts
chmod 600 $PRIVATE_KEY
