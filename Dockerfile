FROM debian:trixie

ARG USR
ARG UID
ARG GID

ENV HOME_DIR=/home/${USR}/
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -y upgrade --no-install-recommends
# base packages
RUN apt-get -y install --no-install-recommends \
  base-passwd \
  bash-completion \
  ca-certificates \
  dumb-init \
  gpg \
  gstreamer1.0-libav \
  htop \
  libdbus-1-3 \
  libglu1-mesa \
  libgstreamer-ocaml \
  libgtk-3-bin \
  libsoup-2.4-1 \
  libwayland-bin \
  libwebkit2gtk-4.1-0 \
  locales \
  sudo \
  tree \
  vim-nox \
  wget

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen 
RUN dpkg-reconfigure --frontend=noninteractive locales 
RUN update-locale LANG=en_US.UTF-8

#COPY develop_AnycubicSlicerNext-1.3.995_20260109_160310-Ubuntu_24_04_3_LTS.deb /tmp
#RUN dpkg -i /tmp/develop_AnycubicSlicerNext-1.3.995_20260109_160310-Ubuntu_24_04_3_LTS.deb

COPY develop_AnycubicSlicerNext-1.3.96_20260131_153250-Ubuntu_24_04_3_LTS.deb /tmp
RUN dpkg -i /tmp/develop_AnycubicSlicerNext-1.3.96_20260131_153250-Ubuntu_24_04_3_LTS.deb

RUN apt-get clean && \
  rm /var/lib/apt/lists/* -rf 

RUN groupadd -g 992 render

RUN groupadd --gid ${GID} ${USR}

RUN useradd \
  --uid ${UID} \
  --gid ${GID} \
  -G render,video \
  --shell /bin/bash \
  --home-dir /home/${USR} \
  --create-home \
  --no-user-group \
  ${USR}

RUN echo "${USR} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

USER ${USR}

WORKDIR ${HOME_DIR}

RUN mkdir -p .config/AnycubicSlicerNext

ENTRYPOINT ["dumb-init", "--"]
CMD ["/bin/bash"]
