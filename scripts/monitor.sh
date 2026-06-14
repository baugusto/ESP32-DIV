#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-/dev/cu.usbmodem1101}"

arduino-cli monitor \
  -p "$PORT" \
  -c baudrate=115200
