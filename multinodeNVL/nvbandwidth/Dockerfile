FROM nvcr.io/nvidia/cuda:12.5.0-devel-ubuntu22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    cmake \
    g++ \
    gcc \
    make \
    libboost-program-options-dev \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /bandwidthtest

ARG NVBANDWIDTH_VERSION=v0.7

RUN git clone --branch ${NVBANDWIDTH_VERSION} --depth 1 --single-branch https://github.com/NVIDIA/nvbandwidth.git && \
    cd nvbandwidth && \
    cmake -DMULTINODE=1 . && \
    make -j$(nproc)

FROM mpioperator/openmpi:v0.6.0

COPY --from=builder /bandwidthtest/nvbandwidth/nvbandwidth /usr/bin

