# Samples provided with the CUDA toolkit.

# docker build -t cuda-vectorAdd .
# docker run --gpus all -ti --rm cuda-vectorAdd

FROM nvidia/cuda:10.2-devel-ubi8

RUN dnf update -y && dnf install -y git make && \
    rm -rf /var/cache/dnf/*

RUN cd /usr/local/cuda-10.2 && \
    git clone https://github.com/NVIDIA/cuda-samples.git && \
    cd cuda-samples && make -j"$(nproc)" -k || true

WORKDIR /usr/local/cuda-10.2/cuda-samples/Samples/vectorAdd_nvrtc

CMD ./vectorAdd_nvrtc
