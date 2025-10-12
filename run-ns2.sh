#!/bin/bash

# Host mount directory here
HOST_SCRIPTS_DIR="$HOME/workspace/ns-2/scripts"

# Allow Docker to access X server (for GUI)
xhost +local:root

# Run the container with:
# - DISPLAY access for nam GUI
# - X11 socket sharing
# - ns2 scripts mounted
docker run -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOST_SCRIPTS_DIR":/root/scripts \
    ns-2.35

# Revoke X access after container exits
xhost -local:root

