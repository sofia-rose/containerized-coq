#!/usr/bin/env bash

set -eu

export SMTCOQ_SHA=80a54a0e1974729d4756d2cc8483a2548c8dd2d0
export COQ_VERSION=8.9.0

export HOST_WORKSPACE=${HOST_WORKSPACE:-${PWD}}
export CONTAINER_WORKSPACE=/home/devuser/workspace

USER_ID=$(id -u)
export USER_ID

GROUP_ID=$(id -g)
export GROUP_ID

IMAGE_REPO=sofiarose/containerized-coq
IMAGE_TAG="smtcoq-${SMTCOQ_SHA}-coq-${COQ_VERSION}-u${USER_ID}-g${GROUP_ID}"

docker run \
  --interactive \
  --tty \
  --rm \
  --volume "${HOST_WORKSPACE}:${CONTAINER_WORKSPACE}" \
  --workdir "${CONTAINER_WORKSPACE}" \
  "${IMAGE_REPO}:${IMAGE_TAG}" \
  bash
