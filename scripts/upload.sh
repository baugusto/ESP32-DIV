#!/usr/bin/env bash
set -euo pipefail

SKETCH_DIR="/Users/baugusto/Projetos/esp32-div-v2.1/ESP32-DIV/ESP32-DIV"
FQBN="esp32:esp32:esp32s3:FlashSize=16M,FlashMode=dio,PartitionScheme=app3M_fat9M_16MB,UploadSpeed=115200,CDCOnBoot=cdc"
PORT="${1:-/dev/cu.usbmodem1101}"

arduino-cli compile \
  --fqbn "$FQBN" \
  --upload \
  -p "$PORT" \
  "$SKETCH_DIR"
