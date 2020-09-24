#!/bin/bash

# nvidia-reset script lives at
# https://git.linaro.org/lava/lava-lab.git/tree/shared/tcwg-scripts/nvidia-reset
exec ssh -p22 dev-01.tcwglab nvidia-reset "$*"
