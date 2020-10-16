#!/usr/bin/env bash
set -exo pipefail

Usage()
{
  echo "Build CUDA sample images."
  echo ""
  echo "  Usage: $0 [OPTIONS]"
  echo ""
  echo "    OPTIONS                        DESCRIPTION"
  echo "    --cuda-version                 Specify the CUDA version"
  echo "    --base-os                      Specify the base OS layer - ubuntu or ubi"
  echo "    --tag                          Specify the image tag"
}

Build()
{
local FILE_EXT=$(echo ${BASEOS} | sed -e 's/[0-9]*$//')
local REPO=nvidia/samples
local SAMPLE=vectoradd
docker build --pull --build-arg CUDA_VER=${CUDA_PKG} --build-arg BASE_DIST=${BASEOS} --tag ${REPO}/${SAMPLE}-cuda${CUDA_PKG}-${BASEOS} --file Dockerfile.${FILE_EXT} .
}

while [[ $# -gt 0 ]]; do
  case $1 in
    "--help"|"-h")  Usage; exit 1 ;;
    "--cuda-version")
          CUDA_PKG=$2
          shift ;;
    "--base-os")
          BASEOS=$2
          shift ;;
    "--tag")
          TAG=$2
          shift ;;
    *)
      echo UNKNOWN OPTION $1
      echo Run $0 -h for help
      exit 1
  esac
  shift 1
done
Build
