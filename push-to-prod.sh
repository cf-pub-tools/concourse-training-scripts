#!/bin/bash

WORKSPACE_IN_CONTAINER=`pwd`
export WORKSPACE_IN_CONTAINER
source "$WORKSPACE_IN_CONTAINER/concourse-scripts/set-ssh-env.sh"
$WORKSPACE_IN_CONTAINER/concourse-scripts/add-ssh.sh

cd $WORKSPACE_IN_CONTAINER/book

bundle install --binstubs && bundle update
bin/bookbinder push_to_prod $1
