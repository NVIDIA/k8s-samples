# vulkaninfo sample compiled from https://github.com/KhronosGroup/Vulkan-Tools

# docker build -t vulkaninfo .

# Docker >= 19.03
# docker run --gpus all --rm vulkaninfo

# Docker < 19.03
# docker run --runtime=nvidia --rm vulkaninfo


FROM nvidia/vulkan:1.1.121-cuda-10.1-alpha

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python3 && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    git clone https://github.com/KhronosGroup/Vulkan-Tools.git /opt/vulkan && \
    cd /opt/vulkan && git checkout $(git describe --tags `git rev-list --tags --max-count=1`) && \
    mkdir build && cd build && \
    cmake .. && make install && \
    rm -rf /opt/vulkan

WORKDIR /usr/local/bin

CMD vulkaninfo

