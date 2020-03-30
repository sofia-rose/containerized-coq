#!/usr/bin/env bash

set -eu

export COQ_VERSION=8.11.0
export OPAM_VERSION=2.0.6

USER_ID=${1:-$(id -u)}
export USER_ID

GROUP_ID=${2:-$(id -g)}
export _GROUP_ID

IMAGE_REPO=sofiarose/containerized-coq
IMAGE_TAG="coq-${COQ_VERSION}-u${USER_ID}-g${GROUP_ID}"

docker build \
  --build-arg "COQ_VERSION=${COQ_VERSION}" \
  --build-arg "OPAM_VERSION=${OPAM_VERSION}" \
  --build-arg "USER_ID=${USER_ID}" \
  --build-arg "GROUP_ID=${GROUP_ID}" \
  --file Dockerfile \
  --tag "${IMAGE_REPO}:${IMAGE_TAG}" \
  .

LATEST_TAG="coq-latest-u${USER_ID}-g${GROUP_ID}"
docker tag \
  "${IMAGE_REPO}:${IMAGE_TAG}" \
  "${IMAGE_REPO}:${LATEST_TAG}"
