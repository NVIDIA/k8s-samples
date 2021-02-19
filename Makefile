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

.DEFAULT_GOAL := noop
noop:
	@echo "Please select a valid target"
	@exit 1

.PHONY: noop

DOCKER ?= docker
ifeq ($(IMAGE),)
REGISTRY ?= nvidia
IMAGE_NAME ?= cuda-sample
IMAGE := $(REGISTRY)/$(IMAGE_NAME)
endif

# Define the CUDA version for which we build the images.
# This can be overridden
CUDA_VERSION ?= 11.1

# The Makefile describes the build process for a single CUDA sample: e.g. `vectorAdd`
ifeq ($(SAMPLE),)
	# Use vectorAdd as the default sample
	SAMPLE := vectorAdd
endif

DISTRIBUTIONS := ubuntu18.04 ubi8
DEFAULT_DISTRIBUTION := ubuntu18.04

LOWER_CASE_SAMPLE := $(shell echo $(SAMPLE) | tr '[:upper:]' '[:lower:]')

.PHONY: build pull push tag

BUILD_TARGETS := $(patsubst %, .build-%, $(DISTRIBUTIONS))
PULL_TARGETS := $(patsubst %, .pull-%, $(DISTRIBUTIONS))
PUSH_TARGETS := $(patsubst %, .push-%, $(DISTRIBUTIONS))
TAG_TARGETS := $(patsubst %, .tag-%, $(DISTRIBUTIONS))
TEST_TARGETS := $(patsubst %, test-%, $(DISTRIBUTIONS))

DISTRIBUTION ?= $(DEFAULT_DISTRIBUTION)
%: %-$(DEFAULT_DISTRIBUTION)

# Define the docker image name and tag
SHORT_IMAGE_TAG = $(LOWER_CASE_SAMPLE)-cuda$(CUDA_VERSION)
IMAGE_TAG = $(SHORT_IMAGE_TAG)-$(DISTRIBUTION)

SAMPLE_IMAGE_NAME = $(IMAGE):$(IMAGE_TAG)

build: .build-$(DEFAULT_DISTRIBUTION)
$(BUILD_TARGETS): .build-%:
	@echo "Building $(SAMPLE) for $(DISTRIBUTION)"
	$(DOCKER) build \
		--build-arg BASE_DIST=$(DISTRIBUTION) \
		--build-arg CUDA_VER=$(CUDA_VERSION) \
		--build-arg SAMPLE_NAME=$(SAMPLE) \
		-t $(SAMPLE_IMAGE_NAME) \
		-f cuda/Dockerfile.$(DISTRIBUTION) \
		cuda

pull: .pull-$(DEFAULT_DISTRIBUTION)
$(PULL_TARGETS): .pull-%:
	$(DOCKER) pull $(SAMPLE_IMAGE_NAME)

OUT_IMAGE ?= $(IMAGE)
OUT_IMAGE_TAG ?= $(IMAGE_TAG)

push: .push-$(DEFAULT_DISTRIBUTION)
.push-$(DEFAULT_DISTRIBUTION): DISTRIBUTION ?= $(DEFAULT_DISTRIBUTION)
$(PUSH_TARGETS): .push-%: .tag-%
	$(DOCKER) push $(OUT_IMAGE):$(OUT_IMAGE_TAG)

.push-$(DEFAULT_DISTRIBUTION): .push-short
.push-short: DISTRIBUTION ?= $(DEFAULT_DISTRIBUTION)
.push-short: .tag-short
	$(DOCKER) push $(OUT_IMAGE):$(SHORT_IMAGE_TAG)

tag: .tag-$(DEFAULT_DISTRIBUTION)
.tag-$(DEFAULT_DISTRIBUTION): DISTRIBUTION ?= $(DEFAULT_DISTRIBUTION)
$(TAG_TARGETS): .tag-%:
	$(DOCKER) tag $(SAMPLE_IMAGE_NAME) $(OUT_IMAGE):$(OUT_IMAGE_TAG)

.tag-$(DEFAULT_DISTRIBUTION): .tag-short
.tag-short: DISTRIBUTION ?= $(DEFAULT_DISTRIBUTION)
.tag-short:
	$(DOCKER) tag $(SAMPLE_IMAGE_NAME) $(OUT_IMAGE):$(SHORT_IMAGE_TAG)
