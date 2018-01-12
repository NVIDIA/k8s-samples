# NVIDIA GameWorks Graphics Samples
# https://github.com/NVIDIAGameWorks/GraphicsSamples

# docker build -t graphics-samples .
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix graphics-samples

FROM nvidia/opengl:1.0-glvnd-devel-centos7

RUN yum install -y \
        git \
	gcc-c++ \
	make \
	libXinerama-devel \
	libXext-devel \
	libXrandr-devel \
	libXi-devel \
	libXcursor-devel \
	libXxf86vm-devel \
	vulkan-devel && \
    rm -rf /var/cache/yum/*

RUN git clone https://github.com/NVIDIAGameWorks/GraphicsSamples.git /opt/demos && \
    cd /opt/demos && \
    git checkout 7ca1360cc547dc3011e2f202554b42fda65eca6d && \
    cd /opt/demos/samples/build/linux64 && make -j"$(nproc)" release && \
    rm -rf /opt/demos/samples/build/linux64

WORKDIR /opt/demos/samples/bin/linux64

CMD ./ThreadedRenderingGL
