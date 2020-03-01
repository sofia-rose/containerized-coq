FROM debian:buster-20200224

ARG OPAM_VERSION
ARG USER_ID
ARG GROUP_ID
ARG COQ_VERSION

RUN apt-get update \
 && apt-get install -y \
    curl \
    darcs \
    g++ \
    gcc \
    libgmp-dev \
    m4 \
    make \
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
 && sha256sum -c /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256

RUN useradd \
    --create-home \
    --shell /bin/bash \
    --uid ${USER_ID} \
    --gid ${GROUP_ID} \
    coquser \
 && echo "coquser ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coquser
ENV HOME /home/coquser

RUN opam init -y \
    --disable-sandboxing \
    --compiler=4.09.0 \
    --dot-profile=${HOME}/.profile \
    --shell-setup \
    --enable-completion \
 && opam update \
 && opam install -y coq=${COQ_VERSION}

USER coquser
WORKDIR /home/coquser/workspace
