#!/usr/bin/env bash

set -eu

export SMTCOQ_VERSION=1.3
export COQ_VERSION=8.9.0

USER_ID=${1:-$(id -u)}
export USER_ID

GROUP_ID=${2:-$(id -g)}
export _GROUP_ID

SMTCOQ_SHA=$(git ls-remote https://github.com/smtcoq/smtcoq master | awk '{print $1}')
export SMTCOQ_SHA

IMAGE_REPO=sofiarose/containerized-coq
IMAGE_TAG="smtcoq-${SMTCOQ_SHA}-coq-${COQ_VERSION}-u${USER_ID}-g${GROUP_ID}"

docker build \
  --build-arg "COQ_VERSION=${COQ_VERSION}" \
  --build-arg "SMTCOQ_VERSION=${SMTCOQ_VERSION}" \
  --build-arg "USER_ID=${USER_ID}" \
  --build-arg "GROUP_ID=${GROUP_ID}" \
  --file Dockerfile \
  --tag "${IMAGE_REPO}:${IMAGE_TAG}" \
  .

LATEST_TAG="smtcoq-latest-coq-${COQ_VERSION}-u${USER_ID}-g${GROUP_ID}"
docker tag \
  "${IMAGE_REPO}:${IMAGE_TAG}" \
  "${IMAGE_REPO}:${LATEST_TAG}"
