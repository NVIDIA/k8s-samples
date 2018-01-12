# Samples provided with the CUDA toolkit.

# docker build -t cuda-samples .
# docker run --runtime=nvidia -ti --rm cuda-samples

FROM nvidia/cuda:9.0-base-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-samples-$CUDA_PKG_VERSION && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/cuda/samples

RUN make -j"$(nproc)" -k || true

CMD ./5_Simulations/nbody/nbody -benchmark -i=10000
