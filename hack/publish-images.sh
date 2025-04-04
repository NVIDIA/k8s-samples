#!/usr/bin/env bash

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

# This script is used to publish images to a registry. It checks whether the image
# already exists in the registry and skips publishing if it does. This can be overridden
# using the FORCE_PUBLISH_IMAGES environment variable.

set -ex

: ${DOCKER=docker}
: ${REGCTL=regctl}

# publish_docker uses docker to publish an image.
# In this case, the image is first retagged (if required) and then pushed.
function publish_docker() {
    if [[ "${1}" != "${2}" ]]; then
        ${DOCKER} tag ${1} ${2}
    fi
    ${DOCKER} push ${2}
}

# publish_regctl uses regctl to copy an image from one registry to another.
# If the two images are the same, this is a no-op.
function publish_regctl() {
    if [[ "${1}" != "${2}" ]]; then
        ${REGCTL} image copy ${1} ${2}
    fi
}

function publish() {
    if [[ $(command -v ${REGCTL}) || x"${BUILD_MULTI_ARCH_IMAGES}" == x"true" ]]; then
        publish_regctl $@
    else
        publish_docker $@
    fi
}

INPUT_IMAGE=$1
shift
if [[ x"${SKIP_FIRST_IMAGE_ON_PUBLISH}" == x"true" ]]; then
    shift
fi

for OUTPUT_IMAGE in "${@}"; do
    echo "Publishing ${INPUT_IMAGE} as ${OUTPUT_IMAGE}"
    publish ${INPUT_IMAGE} ${OUTPUT_IMAGE}
done
