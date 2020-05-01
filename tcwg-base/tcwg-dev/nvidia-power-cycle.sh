#!/bin/bash

exec ssh -p22 dev-01.tcwglab nvidia-reset "$*"
