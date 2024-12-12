FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python3-opencv \
    python3-setuptools \
    python3-matplotlib \
    python3-pyparsing \
    python3-wxgtk4.0 \
    python3-tk \
    python3-lxml \
    python3-scipy \
    python3-future \
    python3-yaml \
    python3-packaging \
    ccache \
    gawk \
    wget \
    rsync \
    libpython3-dev \
    python3-distutils-extra \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /ardupilot

# Clone ArduPilot repository
RUN git clone https://github.com/ArduPilot/ardupilot.git .

# Update submodules
RUN git submodule update --init --recursive

# Install Python packages
RUN pip3 install --break-system-packages \
    future \
    lxml \
    pymavlink \
    MAVProxy \
    numpy \
    pyserial \
    'empy==3.3.4' \
    pexpect \
    dronecan \
    setuptools \
    packaging

# Configure git for waf
RUN git config --global --add safe.directory /ardupilot

# Add start script
COPY start_sitl.sh /ardupilot/
RUN chmod +x /ardupilot/start_sitl.sh

# Build ArduCopter SITL
RUN ./waf configure --board sitl && \
    ./waf build --target bin/arducopter

# Add scripts directory to PATH
ENV PATH="/ardupilot:/ardupilot/Tools/autotest:${PATH}"

# Set default command
CMD ["/ardupilot/start_sitl.sh"]

# Expose MAVLink ports
EXPOSE 5760/tcp 14550/tcp 14551/tcp
