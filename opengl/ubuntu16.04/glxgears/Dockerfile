# glxgears
# ftp://www.x.org/pub/X11R6.8.1/doc/glxgears.1.html

# docker build -t glxgears .
# xhost +si:localuser:root
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix glxgears

FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

RUN apt-get update && apt-get install -y --no-install-recommends \
        mesa-utils && \
    rm -rf /var/lib/apt/lists/*

CMD ["glxgears", "-info"]
