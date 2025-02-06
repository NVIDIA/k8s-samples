FROM nvcr.io/nvidia/cuda:12.5.0-devel-ubuntu22.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake g++ gcc make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /sample

# Clone CUDA Samples repository and build simpleMultiGPU
RUN git clone https://github.com/NVIDIA/cuda-samples.git && \
    cd cuda-samples/Samples/0_Introduction/simpleMultiGPU && \
    make -j$(nproc)

FROM nvcr.io/nvidia/cuda:12.5.0-base-ubuntu22.04

COPY --from=builder /sample/cuda-samples/Samples/0_Introduction/simpleMultiGPU/simpleMultiGPU .

CMD ["./simpleMultiGPU"]
