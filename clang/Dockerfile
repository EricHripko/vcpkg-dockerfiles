FROM ubuntu:20.04

# System dependencies
ARG CLANG_VERSION=9
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        cmake \
        curl \
        clang-${CLANG_VERSION} \
        git \
        make \
        unzip \
        tar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install vcpkg
ENV CC=/usr/bin/clang \
    CXX=/usr/bin/clang++ \
    VCPKG_PATH=/opt/vcpkg/bin
ENV PATH=$PATH:$VCPKG_PATH
RUN mkdir -p $VCPKG_PATH && \
    git clone https://github.com/Microsoft/vcpkg.git $VCPKG_PATH && \
    cd $VCPKG_PATH && \
    ./bootstrap-vcpkg.sh
