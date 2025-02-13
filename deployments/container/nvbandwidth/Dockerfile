# Copyright (c) 2025, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM nvcr.io/nvidia/cuda:12.6.2-devel-ubuntu22.04 AS builder

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

