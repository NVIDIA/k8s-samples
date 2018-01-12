# Samples provided with the CUDA toolkit.

# docker build -t cuda-samples .
# docker run --runtime=nvidia -ti --rm cuda-samples

FROM nvidia/cuda:9.0-base-centos7

RUN yum install -y \
        cuda-samples-$CUDA_PKG_VERSION && \
    rm -rf /var/cache/yum/*

WORKDIR /usr/local/cuda/samples

RUN make -j"$(nproc)" -k || true

CMD ./5_Simulations/nbody/nbody -benchmark -i=10000
