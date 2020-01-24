# Samples provided with the CUDA toolkit.

# docker build -t cuda-vectorAdd .
# docker run --gpus all -ti --rm cuda-vectorAdd

FROM nvidia/cuda:10.2-devel-ubi8

RUN dnf update -y && dnf install -y git make && \
    rm -rf /var/cache/dnf/*

WORKDIR /usr/local/cuda-10.2

RUN git clone https://github.com/NVIDIA/cuda-samples.git && \
    cd cuda-samples && make -j"$(nproc)" -k || true 

CMD ./cuda-samples/Samples/vectorAdd_nvrtc/vectorAdd_nvrtc
