# nbody graphical sample provided with the CUDA toolkit.

# docker build -t nbody .
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix nbody

FROM nvidia/cudagl:9.0-base-centos7

RUN yum install -y \
        cuda-samples-$CUDA_PKG_VERSION && \
    rm -rf /var/cache/yum/*

WORKDIR /usr/local/cuda/samples/5_Simulations/nbody

RUN make

CMD ./nbody
