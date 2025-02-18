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

BUILD_MULTI_ARCH_IMAGES ?= false
DOCKER ?= docker
BUILDX  =
ifeq ($(BUILD_MULTI_ARCH_IMAGES),true)
BUILDX = buildx
endif

CUDA_VERSION ?= 12.5.0
NVBANDWIDTH_VERSION ?= v0.7

ifeq ($(IMAGE_NAME),)
REGISTRY ?= nvidia/k8s-samples
IMAGE_NAME := $(REGISTRY):nvbandwidth
endif

IMAGE_TAG = $(IMAGE_NAME)-$(NVBANDWIDTH_VERSION)

PUSH_ON_BUILD ?= false
DOCKER_BUILD_OPTIONS = --output=type=image,push=$(PUSH_ON_BUILD)
DOCKER_BUILD_PLATFORM_OPTIONS = --platform=linux/amd64,linux/arm64
DOCKERFILE = $(CURDIR)/multinodeNVL/nvbandwidth/Dockerfile

.PHONY: build

build:
	DOCKER_BUILDKIT=1 \
		$(DOCKER) $(BUILDX) build --pull \
		--provenance=false --sbom=false \
		$(DOCKER_BUILD_OPTIONS) \
		$(DOCKER_BUILD_PLATFORM_OPTIONS) \
		--tag $(IMAGE_TAG) \
		--build-arg CUDA_VERSION="$(CUDA_VERSION)" \
		--build-arg NVBANDWIDTH_VERSION="$(NVBANDWIDTH_VERSION)" \
		-f $(DOCKERFILE) \
		$(CURDIR)
