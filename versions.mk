# Copyright (c) 2022, NVIDIA CORPORATION.  All rights reserved.
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

# Specify the CUDA base image version
VERSION ?= cuda$(shell  grep -Eo "FROM.*cuda:[0-9\.]+" deployments/container/Dockerfile.ubuntu | sort -u | sed 's/.*://g')

# Specify the tag for the https://github.com/NVIDIA/cuda-samples repository.
# This need not match the CUDA_VERSION above.
CUDA_SAMPLES_VERSION := v12.0

ifeq ($(IMAGE_NAME),)
REGISTRY ?= nvcr.io/nvidia/k8s
IMAGE_NAME := $(REGISTRY)/cuda-sample
endif
