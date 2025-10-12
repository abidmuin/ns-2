FROM ubuntu:16.04

LABEL maintainer="muin.739@gmail.com"
LABEL description="Install NS-2 using Docker"

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-4.8 \
    g++-4.8 \
    perl \
    libxt-dev \
    libx11-dev \
    xorg \
    libxmu-dev \
    libxmu-headers \
    libtool \
    automake \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set GCC 4.8 as default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100 \
 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 100

# Create working directory
WORKDIR /opt/

# Download and extract ns-2.35
RUN wget https://sourceforge.net/projects/nsnam/files/allinone/ns-allinone-2.35/ns-allinone-2.35.tar.gz \
 && tar -xvzf ns-allinone-2.35.tar.gz \
 && rm ns-allinone-2.35.tar.gz

# Apply patches to fix common compilation errors
WORKDIR /opt/ns-allinone-2.35/ns-2.35
RUN sed -i 's/erase(baseMap::begin(), baseMap::end())/this->erase(this->begin(), this->end())/' linkstate/ls.h && \
    sed -i 's/baseList::erase(baseList::begin(), baseList::end())/this->erase(this->begin(), this->end())/' linkstate/ls.h

# Build ns-2.35
WORKDIR /opt/ns-allinone-2.35
RUN ./install

# Manually build nam to ensure it compiles correctly
WORKDIR /root/scripts

# Add ns path to environment
ENV PATH="/opt/ns-allinone-2.35/bin:/opt/ns-allinone-2.35/tcl8.5.10/unix:/opt/ns-allinone-2.35/tk8.5.10/unix:$PATH"

# Default shell
CMD ["/bin/bash"]

