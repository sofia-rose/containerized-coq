#!/usr/bin/env bash

set -eu

export COQ_VERSION=8.11.0
export OPAM_VERSION=2.0.6
export USER_ID=`id -u`
export GROUP_ID=`id -g`

docker build \
  --build-arg COQ_VERSION=${COQ_VERSION} \
  --build-arg OPAM_VERSION=${OPAM_VERSION} \
  --build-arg USER_ID=${USER_ID}  \
  --build-arg GROUP_ID=${GROUP_ID} \
  --tag coq:${COQ_VERSION} \
  .

docker run \
  --interactive \
  --tty \
  --rm \
  --volume $PWD/workspace:/home/coquser/workspace \
  coq:${COQ_VERSION} \
  /bin/bash -l
