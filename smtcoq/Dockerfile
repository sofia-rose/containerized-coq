ARG USER_ID
ARG GROUP_ID

FROM sofiarose/containerized-coq:coq-latest-u${USER_ID}-g${GROUP_ID}

ARG COQ_VERSION
ARG SMTCOQ_VERSION

RUN sudo apt-get install -y \
    autoconf \
    bison \
    cvc4 \
    flex

ADD veriT9f48a98.tar.gz $HOME/tmp

RUN cd $HOME/tmp/veriT9f48a98 \
  && autoconf \
  && ./configure \
  && make \
  && sudo mv veriT /usr/local/bin/ \
  && sudo mv veriT-SAT /usr/local/bin/ \
  && sudo rm -rf $HOME/tmp/veriT9f48a98

RUN opam pin -y add coq ${COQ_VERSION} \
 && opam install -y coq-smtcoq

COPY smtcoq_example.v $HOME/
RUN sudo chown devuser: $HOME/smtcoq_example.v
