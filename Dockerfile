FROM debian:stretch AS build
RUN echo "#" >> /etc/apt/sources.list && cat /etc/apt/sources.list | sed 's/deb /deb-src /g' >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get -y build-dep libnfc libfreefare libusb \
    && apt-get install -y git libpcsclite-dev doxygen zip \
    && rm -rf /var/lib/apt/lists/*

ENV LIBNFC_LIB=/src/libnfc

ARG LIBNFC_REPOSITORY=https://github.com/nfc-tools/libnfc.git
ARG LIBNFC_BRANCH=libnfc-1.7.1

ARG LIBFREEFARE_REPOSITORY=https://github.com/nfc-tools/libfreefare.git
ARG LIBFREEFARE_BRANCH=libfreefare-0.4.0

ARG LIBPIGPIO_REPOSITORY=https://github.com/joan2937/pigpio.git
ARG LIBPIGPIO_BRANCH=master

WORKDIR /src/pigpio
RUN git clone $LIBPIGPIO_REPOSITORY --recursive --depth=1 --branch=$LIBPIGPIO_BRANCH .
RUN make

WORKDIR /src/libnfc
RUN git clone $LIBNFC_REPOSITORY --recursive --depth=1 --branch=$LIBNFC_BRANCH .
RUN autoreconf -vis && ./configure --enable-doc && make

WORKDIR /src/libfreefare
RUN git clone $LIBFREEFARE_REPOSITORY --recursive --depth=1 --branch=$LIBFREEFARE_BRANCH .
RUN autoreconf -vis && ./configure && make

ENTRYPOINT [ "bash" ]