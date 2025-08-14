# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
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

FROM nvcr.io/nvidia/cuda:13.0.0-base-ubuntu22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    wget \
    && \
    rm -rf /var/lib/apt/lists/*

# See instructions from https://vulkan.lunarg.com/doc/sdk/1.4.309.0/linux/getting_started_ubuntu.html
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc \
    && \
    wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list http://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list \
    && \
    apt update -y \
    && \
    apt install -y --no-install-recommends vulkan-sdk \
    && \
    rm -rf /var/lib/apt/lists/*

# TODO: Should we include this in the list above.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    make \
    cmake \
    pkg-config \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ARG BUILD_EXAMPLES="computeheadless renderheadless"
ENV BUILD_EXAMPLES=$BUILD_EXAMPLES

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglm-dev \
    && rm -rf /var/lib/apt/lists/*

# TODO: We should update to the official samples
RUN git clone --depth=1 https://github.com/SaschaWillems/Vulkan.git \
    && cd Vulkan \
    sed -e 's|https://|git@|g' .gitmodules \
    && \
    git submodule sync \
    && \
    git submodule update \
    && mkdir -p build && cd build \
    && cmake -D RESOURCE_INSTALL_DIR=/cuda-samples ..  \
    && make ${BUILD_EXAMPLES}

FROM nvcr.io/nvidia/cuda:13.0.0-base-ubuntu22.04

LABEL io.k8s.display-name="NVIDIA CUDA Vulkan samples"
LABEL name="NVIDIA CUDA Vulkan samples"
LABEL vendor="NVIDIA"
LABEL version="N/A"
LABEL release="N/A"
LABEL summary="NVIDIA container to validate GPU support for Vulkan"
LABEL description="See summary"

COPY ./LICENSE ./licenses/LICENSE

RUN mkdir -p /cuda-samples

COPY --from=builder /build/Vulkan/build/bin/computeheadless /cuda-samples/bin/computeheadless
COPY --from=builder /build/Vulkan/build/bin/renderheadless /cuda-samples/bin/renderheadless
COPY --from=builder /build/Vulkan/shaders/glsl/computeheadless/ /cuda-samples/shaders/glsl/computeheadless/
COPY --from=builder /build/Vulkan/shaders/glsl/renderheadless/ /cuda-samples/shaders/glsl/renderheadless/
COPY --from=builder /build/Vulkan/shaders/hlsl/computeheadless/ /cuda-samples/shaders/hlsl/computeheadless/
COPY --from=builder /build/Vulkan/shaders/hlsl/renderheadless/ /cuda-samples/shaders/hlsl/renderheadless/

COPY /deployments/container/vulkan/entrypoint.sh /cuda-samples/entrypoint.sh
RUN ln -s /cuda-samples/entrypoint.sh /cuda-samples/sample

ENV DEBIAN_FRONTEND=noninteractive
COPY --from=builder /etc/apt/sources.list.d/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/lunarg-vulkan-jammy.list
COPY --from=builder /etc/apt/trusted.gpg.d/lunarg.asc /etc/apt/trusted.gpg.d/lunarg.asc

RUN apt update -y && apt install -y --no-install-recommends \
        vulkan-sdk \
    && \
    rm -rf /var/lib/apt/lists/*

CMD ["/cuda-samples/sample"]
