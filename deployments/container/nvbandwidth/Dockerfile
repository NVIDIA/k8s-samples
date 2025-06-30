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

FROM nvcr.io/nvidia/cuda:12.9.1-devel-ubuntu22.04 AS builder

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

FROM nvcr.io/nvidia/cuda:12.9.1-base-ubuntu22.04

ARG port=2222

RUN apt-get update && apt-get install -y --no-install-recommends \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev \
    openssh-client \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd

# Got it from mpi-operator/build/base/Dockerfile
# Allow OpenSSH to talk to containers without asking for confirmation
# by disabling StrictHostKeyChecking.
# mpi-operator mounts the .ssh folder from a Secret. For that to work, we need
# to disable UserKnownHostsFile to avoid write permissions.
# Disabling StrictModes avoids directory and files read permission checks.
RUN sed -i 's/[ #]\(.*StrictHostKeyChecking \).*/ \1no/g' /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    sed -i "s/[ #]\(.*Port \).*/ \1$port/g" /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config && \
    sed -i "s/#\(Port \).*/\1$port/g" /etc/ssh/sshd_config

RUN useradd -m mpiuser
WORKDIR /home/mpiuser

COPY --chown=mpiuser ./deployments/container/nvbandwidth/sshd_config .sshd_config
RUN echo "Port $port" >> /home/mpiuser/.sshd_config

COPY --from=builder /bandwidthtest/nvbandwidth/nvbandwidth /usr/bin

ENTRYPOINT ["mpirun"]
