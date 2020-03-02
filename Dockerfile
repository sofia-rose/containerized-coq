FROM debian:buster-20200224

ARG OPAM_VERSION
ARG USER_ID
ARG GROUP_ID
ARG COQ_VERSION

RUN apt-get update \
 && apt-get install -y \
    autoconf \
    bison \
    curl \
    cvc4 \
    darcs \
    flex \
    g++ \
    gcc \
    git \
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
ADD veriT9f48a98.tar.gz /tmp/

RUN curl -sSLo /usr/local/bin/opam \
  https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/opam-${OPAM_VERSION}-x86_64-linux \
 && chmod +x /usr/local/bin/opam \
 && sha256sum -c /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256 \
 && cd /tmp/veriT9f48a98 \
 && autoconf \
 && ./configure \
 && make \
 && mv veriT /usr/local/bin/ \
 && mv veriT-SAT /usr/local/bin/ \
 && cd / \
 && rm /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256 \
 && rm -rf /tmp/veriT9f48a98*

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
    --dot-profile=${HOME}/.bashrc \
    --shell-setup \
    --enable-completion \
 && opam update \
 && opam repo add coq-released https://coq.inria.fr/opam/released \
 && opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev \
 && opam install -y \
    coq=${COQ_VERSION} \
    coq-smtcoq

WORKDIR /home/coquser/workspace
