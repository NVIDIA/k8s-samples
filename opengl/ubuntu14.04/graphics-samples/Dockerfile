# NVIDIA GameWorks Graphics Samples
# https://github.com/NVIDIAGameWorks/GraphicsSamples

# docker build -t graphics-samples .
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix graphics-samples

FROM nvidia/opengl:1.0-glvnd-devel-ubuntu14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        build-essential \
        g++ \
        libxinerama-dev \
        libxext-dev \
        libxrandr-dev \
        libxi-dev \
        libxcursor-dev \
        libxxf86vm-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/NVIDIAGameWorks/GraphicsSamples.git /opt/demos && \
    cd /opt/demos && \
    git checkout 7ca1360cc547dc3011e2f202554b42fda65eca6d && \
    cd /opt/demos/samples/build/linux64 && { make -k -j"$(nproc)" release || true ; } && \
    rm -rf /opt/demos/samples/build/linux64

WORKDIR /opt/demos/samples/bin/linux64

CMD ./ThreadedRenderingGL
