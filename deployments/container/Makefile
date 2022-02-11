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

DOCKER ?= docker
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

DEFAULT_DISTRIBUTION := ubuntu18.04
DISTRIBUTIONS := ubuntu18.04 ubuntu20.04 ubi8

BUILD_TARGETS := $(patsubst %,build-%, $(DISTRIBUTIONS))
PUSH_TARGETS := $(patsubst %,push-%, $(DISTRIBUTIONS))
TEST_TARGETS := $(patsubst %,test-%, $(DISTRIBUTIONS))

.PHONY: $(DISTRIBUTIONS) $(PUSH_TARGETS) $(BUILD_TARGETS) $(TEST_TARGETS)

push-%: DIST = $(*)
$(PUSH_TARGETS): push-%:
	$(DOCKER) push "$(IMAGE_NAME):$(IMAGE_TAG)"

# For the default push target we also push a short tag equal to the version.
# We skip this for the development release
DEVEL_RELEASE_IMAGE_VERSION ?= devel
ifneq ($(strip $(VERSION)),$(DEVEL_RELEASE_IMAGE_VERSION))
push-$(DEFAULT_DISTRIBUTION): push-short push-sample
endif
push-short:
	$(DOCKER) tag "$(IMAGE_NAME):$(IMAGE_VERSION)-$(DEFAULT_DISTRIBUTION)" "$(IMAGE_NAME):$(IMAGE_VERSION)"
	$(DOCKER) push "$(IMAGE_NAME):$(IMAGE_VERSION)"

push-sample:
	$(DOCKER) tag "$(IMAGE_NAME):$(IMAGE_VERSION)-$(DEFAULT_DISTRIBUTION)" "$(IMAGE_NAME):$(LOWER_CASE_SAMPLE)"
	$(DOCKER) push "$(IMAGE_NAME):$(LOWER_CASE_SAMPLE)"


build-%: DIST = $(*)
build-%: DOCKERFILE = $(CURDIR)/deployments/container/Dockerfile.$(DOCKERFILE_SUFFIX)

build-ubuntu%: DOCKERFILE_SUFFIX = ubuntu

build-ubi8: DOCKERFILE_SUFFIX = ubi8

# Use a generic build target to build the relevant images
$(BUILD_TARGETS): build-%:
	DOCKER_BUILDKIT=1 \
		$(DOCKER) build --pull \
		--platform=linux/amd64 \
		--tag $(IMAGE) \
		--build-arg BASE_DIST="$(DIST)" \
		--build-arg CUDA_VERSION="$(CUDA_VERSION)" \
		--build-arg SAMPLE_NAME=$(SAMPLE) \
		-f $(DOCKERFILE) \
		$(CURDIR)
