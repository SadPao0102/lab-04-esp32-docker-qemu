FROM espressif/idf:v5.1

# Install additional tools
RUN apt-get update && apt-get install -y \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3-pip \
    python3-setuptools \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install QEMU for ESP32 simulation
RUN apt-get update && apt-get install -y \
    qemu-system-xtensa \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /project

# Copy project files
COPY . /project

# Set environment variables
ENV IDF_PATH=/opt/esp/idf
ENV PATH="${IDF_PATH}/tools:${PATH}"

# Default command
CMD ["bash"]
