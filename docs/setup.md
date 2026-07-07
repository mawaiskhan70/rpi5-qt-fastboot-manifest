# Setup Guide

## Prerequisites

### Hardware
- Raspberry Pi 5 (8GB)
- SD card — A2-rated recommended (SanDisk Extreme Pro, Samsung Pro)
- HDMI display
- USB-C power supply (27W recommended for RPi5)

### Software (Ubuntu host)
```bash
# Docker
sudo apt install docker.io
sudo usermod -aG docker $USER
# Log out and back in after this

# kas-container (run from manifest repo root)
curl -fsSL https://raw.githubusercontent.com/siemens/kas/refs/heads/master/kas-container \
    -o kas-container && chmod +x kas-container

# Flashing tool
sudo apt install bmap-tools

# Serial console (optional but recommended)
sudo apt install minicom
```

## First Build

```bash
# Clone repos
git clone https://github.com/mawaiskhan70/rpi5-qt-fastboot-manifest.git
cd rpi5-qt-fastboot-manifest

# Install kas-container
curl -fsSL https://raw.githubusercontent.com/siemens/kas/refs/heads/master/kas-container \
    -o kas-container && chmod +x kas-container

# Build SD card image (first build takes 4–8 hours)
./scripts/build.sh sd

# Flash to SD card (replace /dev/sdX with your card)
lsblk   # identify your SD card device
./scripts/flash.sh sd /dev/sdX
```

## Disk Space
Ensure 250–300 GB free on an SSD before building.
- `build/`       — 20–50 GB (TMPDIR, wiped with cleansstate)
- `downloads/`   — 10–20 GB (source cache, keep between builds)
- `sstate-cache/` — 30–80 GB (build cache, keep between builds)

## Common Commands

```bash
# Full image build
./scripts/build.sh sd

# Drop into BitBake shell
./scripts/build.sh sd shell

# Build single recipe
./scripts/build.sh sd bitbake <recipe-name>

# Measure boot time breakdown
systemd-analyze time
systemd-analyze blame
systemd-analyze critical-chain
```

## Serial Console (UART debug)
Connect USB-UART adapter to RPi5 GPIO pins 14/15 (TX/RX) + GND.
```bash
minicom -D /dev/ttyUSB0 -b 115200
```
Essential when display is not yet initialized during early boot debugging.
