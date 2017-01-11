#!/usr/bin/env bash

set -e

echo "$GITHUB_SSH_KEY" > github_private_key.pem
chmod 0600 github_private_key.pem
eval $(ssh-agent)
ssh-add github_private_key.pem > /dev/null

set -x

cp cf-vars/vars.yml greenhouse-private/$ENVIRONMENT/cf/
pushd greenhouse-private/$ENVIRONMENT/cf >/dev/null
  git config user.email "pivotal-netgarden-eng@pivotal.io"
  git config user.name "CI (Automated)"
	git add vars.yml
	git commit -m "Update cf-vars for $ENVIRONMENT"
	git push
popd >/dev/null
