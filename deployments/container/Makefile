# Copyright (c) 2021-2022, NVIDIA CORPORATION.  All rights reserved.
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

BUILD_MULTI_ARCH_IMAGES ?= true
DOCKER ?= docker
BUILDX ?= buildx
MKDIR  ?= mkdir

include $(CURDIR)/versions.mk

IMAGE_VERSION := $(VERSION)

IMAGE_TAG ?= $(SAMPLE)-$(VERSION)
IMAGE = $(IMAGE_NAME):$(IMAGE_TAG)

SAMPLES := vectoradd nbody devicequery simplemultigpu vulkan nvbandwidth

IMAGE_TARGETS := $(patsubst %,image-%,$(SAMPLES))
BUILD_TARGETS := $(patsubst %,build-%,$(SAMPLES))

.PHONY: $(SAMPLES) $(BUILD_TARGETS) $(IMAGE_TARGETS)

# Certain samples do not allow multi-arch images. We disable them here.
# TODO: Does it make more sense to set this at a CI-level?
image-nbody: DOCKER_BUILD_PLATFORM_OPTIONS = --platform=linux/$(ARCH)
image-vulkan: DOCKER_BUILD_PLATFORM_OPTIONS = --platform=linux/$(ARCH)

image-%: SAMPLE = $(*)
image-%: SAMPLE_NAME = $(*)
image-%: DOCKERFILE = $(CURDIR)/deployments/container/$(*)/Dockerfile
image-%: ARCH ?= $(shell uname -m)
image-%: DOCKER_BUILD_OPTIONS = --output=type=image,push=$(PUSH_ON_BUILD)
image-%: DOCKER_BUILD_PLATFORM_OPTIONS = --platform=linux/amd64,linux/arm64

# TODO: We should switch to single ubi9 images where possible
image-devicequery: DOCKERFILE = $(CURDIR)/deployments/container/Dockerfile
image-devicequery: SAMPLE_NAME = deviceQuery
image-simplemultigpu: DOCKERFILE = $(CURDIR)/deployments/container/Dockerfile
image-simplemultigpu: SAMPLE_NAME = simpleMultiGPU
image-vectoradd: DOCKERFILE = $(CURDIR)/deployments/container/Dockerfile
image-vectoradd: SAMPLE_NAME = vectorAdd


# Use a generic build target to build the relevant images
$(IMAGE_TARGETS): image-%:
	DOCKER_BUILDKIT=1 \
		$(DOCKER) $(BUILDX) build --pull \
		--provenance=false --sbom=false \
		$(DOCKER_BUILD_OPTIONS) \
		$(DOCKER_BUILD_PLATFORM_OPTIONS) \
		--tag $(IMAGE) \
		--build-arg CUDA_SAMPLES_VERSION="$(CUDA_SAMPLES_VERSION)" \
		--build-arg SAMPLE_NAME="$(SAMPLE_NAME)" \
		--build-arg VERSION="$(VERSION)" \
		-f $(DOCKERFILE) \
		$(CURDIR)

$(BUILD_TARGETS): build-%: image-%
