FROM debian:buster-20200224

ARG OPAM_VERSION
ARG COQ_VERSION

RUN apt-get update \
 && apt-get install -y \
    curl \
    darcs \
    g++ \
    gcc \
    git \
    libgmp-dev \
    m4 \
    make \
    man \
    mercurial \
    patch \
    pkg-config \
    rsync \
    sudo \
    unzip

ADD opam-${OPAM_VERSION}-x86_64-linux.sha256 /tmp/

RUN curl -sSLo /usr/local/bin/opam \
  https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/opam-${OPAM_VERSION}-x86_64-linux \
 && chmod +x /usr/local/bin/opam \
 && sha256sum -c /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256 \
 && rm /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256

ARG USER_ID
ARG GROUP_ID

RUN useradd \
      --create-home \
      --shell /bin/bash \
      --uid "${USER_ID}" \
      --gid "${GROUP_ID}" \
      devuser \
 && echo "devuser ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV HOME /home/devuser
WORKDIR $HOME
USER devuser

RUN opam init -y \
    --disable-sandboxing \
    --compiler=4.09.0 \
    --dot-profile=/home/devuser/.bashrc \
    --shell-setup \
    --enable-completion \
 && opam update \
 && opam repo add coq-released https://coq.inria.fr/opam/released \
 && opam repo add coq-core-dev https://coq.inria.fr/opam/core-dev \
 && opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev \
 && opam pin -y add coq ${COQ_VERSION}
