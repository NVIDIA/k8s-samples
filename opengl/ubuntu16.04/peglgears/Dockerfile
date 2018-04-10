# peglgears from Mesa demos
# ftp://ftp.freedesktop.org/pub/mesa/demos/8.3.0/

# docker build -t peglgears .
# docker run --runtime=nvidia -ti --rm peglgears

FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

ENV NVIDIA_REQUIRE_DRIVER "driver>=390"

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        g++ \
        libglew-dev \
        freeglut3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://mesa.freedesktop.org/archive/demos/8.3.0/mesa-demos-8.3.0.tar.gz -O && \
    tar -xzf mesa-demos-8.3.0.tar.gz -C /opt && \
    rm mesa-demos-8.3.0.tar.gz && \
    cd /opt/mesa-demos-8.3.0 && \
    ./configure --enable-egl=yes && \
    make -j"$(nproc)"

CMD /opt/mesa-demos-8.3.0/src/egl/opengl/peglgears
