# Copyright (c) 2021, NVIDIA CORPORATION.  All rights reserved.
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

FROM nvcr.io/nvidia/cuda:12.9.1-base-ubuntu22.04 AS builder

ARG SAMPLE_NAME=nbody
ENV SAMPLE_NAME=${SAMPLE_NAME}

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        cuda-nvcc-12-9 \
        g++ \
        curl \
        freeglut3-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
    && \
        rm -rf /var/lib/apt/lists/*

WORKDIR /build

ARG TARGETARCH

ARG CUDA_SAMPLES_VERSION=v12.9
RUN curl -L https://codeload.github.com/NVIDIA/cuda-samples/tar.gz/refs/tags/${CUDA_SAMPLES_VERSION} | \
    tar -xzvf - --strip-components=1 --wildcards */${SAMPLE_NAME}/* --wildcards */Common/* && \
    cd $(find /build/Samples -iname "${SAMPLE_NAME}") && \
    cmake . && \
    make && \
    cp ${SAMPLE_NAME} /build/${SAMPLE_NAME}

FROM nvcr.io/nvidia/cuda:12.9.1-base-ubuntu22.04
ARG SAMPLE_NAME=nbody
LABEL io.k8s.display-name="NVIDIA CUDA ${SAMPLE_NAME} sample"
LABEL name="NVIDIA CUDA ${SAMPLE_NAME} sample"
LABEL vendor="NVIDIA"
LABEL version="1.0.0"
LABEL release="N/A"
LABEL summary="NVIDIA container to validate GPU support"
LABEL description="See summary"

# The nbody sample requires libGL, libGLU, and libglut
RUN apt-get update && apt-get install -y --no-install-recommends \
        freeglut3 \
        libgl1 \
        libglu1 \
    && \
        rm -rf /var/lib/apt/lists/* || :

COPY ./LICENSE ./licenses/LICENSE

RUN mkdir -p /cuda-samples
COPY --from=builder /build/${SAMPLE_NAME} /cuda-samples/${SAMPLE_NAME}

RUN ln -s /cuda-samples/${SAMPLE_NAME} /cuda-samples/sample
ENTRYPOINT ["/cuda-samples/sample"]
