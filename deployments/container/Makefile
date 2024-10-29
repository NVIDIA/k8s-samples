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

BUILD_MULTI_ARCH_IMAGES ?= false
DOCKER ?= docker
BUILDX  =
ifeq ($(BUILD_MULTI_ARCH_IMAGES),true)
BUILDX = buildx
endif
MKDIR  ?= mkdir

include $(CURDIR)/versions.mk

ifeq ($(IMAGE_NAME),)
REGISTRY ?= nvidia
IMAGE_NAME := $(REGISTRY)/cuda-sample
endif

# The Makefile describes the build process for a single CUDA sample: e.g. `vectorAdd`
ifeq ($(SAMPLE),)
# Use vectorAdd as the default sample
	SAMPLE := vectorAdd
endif
LOWER_CASE_SAMPLE := $(shell echo $(SAMPLE) | tr '[:upper:]' '[:lower:]')

IMAGE_VERSION := $(LOWER_CASE_SAMPLE)-$(VERSION)

IMAGE_TAG ?= $(IMAGE_VERSION)-$(DIST)
IMAGE = $(IMAGE_NAME):$(IMAGE_TAG)

OUT_IMAGE_NAME ?= $(IMAGE_NAME)
OUT_IMAGE_VERSION ?= $(VERSION)
OUT_IMAGE_TAG ?= $(LOWER_CASE_SAMPLE)-$(OUT_IMAGE_VERSION)-$(DIST)
OUT_IMAGE = $(OUT_IMAGE_NAME):$(OUT_IMAGE_TAG)

DEFAULT_PUSH_TARGET := ubuntu22.04
DISTRIBUTIONS := ubuntu22.04 ubi9

BUILD_TARGETS := $(patsubst %,build-%, $(DISTRIBUTIONS))
PUSH_TARGETS := $(patsubst %,push-%, $(DISTRIBUTIONS))
TEST_TARGETS := $(patsubst %,test-%, $(DISTRIBUTIONS))

.PHONY: $(DISTRIBUTIONS) $(PUSH_TARGETS) $(BUILD_TARGETS) $(TEST_TARGETS)

ifneq ($(BUILD_MULTI_ARCH_IMAGES),true)
include $(CURDIR)/deployments/container/native-only.mk
else
include $(CURDIR)/deployments/container/multi-arch.mk
endif

push-%: DIST = $(*)
push-short: DIST = $(DEFAULT_PUSH_TARGET)
push-sample: DIST = $(DEFAULT_PUSH_TARGET)

# For the default push target we also push a short tag equal to the version.
# We skip this for the development release
DEVEL_RELEASE_IMAGE_VERSION ?= devel
PUSH_MULTIPLE_TAGS ?= true
PUSH_SAMPLE_ONLY_TAG ?= false
ifeq ($(strip $(OUT_IMAGE_VERSION)),$(DEVEL_RELEASE_IMAGE_VERSION))
PUSH_MULTIPLE_TAGS = false
endif
ifeq ($(PUSH_MULTIPLE_TAGS),true)
push-$(DEFAULT_PUSH_TARGET): push-short
# If required we retag and push the image tagged only with the sample name
ifeq ($(PUSH_SAMPLE_ONLY_TAG),true)
push-$(DEFAULT_PUSH_TARGET): push-sample
endif
endif

build-%: DIST = $(*)
build-%: DOCKERFILE = $(CURDIR)/deployments/container/Dockerfile.$(DOCKERFILE_SUFFIX)

build-ubuntu%: DOCKERFILE_SUFFIX = ubuntu

build-ubi9: DOCKERFILE_SUFFIX = ubi9

# Use a generic build target to build the relevant images
$(BUILD_TARGETS): build-%:
	DOCKER_BUILDKIT=1 \
		$(DOCKER) $(BUILDX) build --pull \
		--provenance=false --sbom=false \
		$(DOCKER_BUILD_OPTIONS) \
		$(DOCKER_BUILD_PLATFORM_OPTIONS) \
		--tag $(IMAGE) \
		--build-arg CUDA_SAMPLES_VERSION="$(CUDA_SAMPLES_VERSION)" \
		--build-arg SAMPLE_NAME=$(SAMPLE) \
		-f $(DOCKERFILE) \
		$(CURDIR)
