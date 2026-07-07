# Project Architecture

## Goal
Minimum wall-clock boot time to first Qt6 QML frame on Raspberry Pi 5 (8GB).

## Display Stack Decision

No Weston. No Wayland. No X11.

Weston is a full compositor — it manages multiple clients sharing one display.
For a single full-screen Qt app it adds 300ms-1.5s of startup overhead with
zero benefit. EGLFS talks directly to KMS/DRM — your Qt app is the only
process that touches the display.

Display stack:
  Qt6 QML App
    -> Qt EGLFS platform plugin
      -> eglfs_kms backend
        -> KMS/DRM (kernel)
          -> V3D GPU driver (VC4)
            -> HDMI display

## Bootloader Decision

No U-Boot.

RPi5 EEPROM boots the Linux kernel directly. U-Boot would add 200-800ms
of pure overhead for a fixed-hardware, single-application deployment.
The RPi5 EEPROM bootloader is configured via config.txt — that is your
bootloader interface.

## Boot Phase Breakdown

Power ON
  |
  v
EEPROM + VideoCore firmware + storage init    ~4-6s SD / ~3-5s NVMe
  |                                           NOT measured by systemd-analyze
  |                                           NOT tunable by Yocto
  v
Kernel boot (custom trimmed config)           ~1.0-1.5s
  |
  v
Userspace -> init -> Qt app exec              ~0.5-1.0s
  |
  v
Qt EGLFS init + QML first frame              ~0.5-1.0s
  |
  v
First pixel on screen

## Realistic Targets

Storage  | Optimized minimum | Notes
---------|-------------------|-------------------------
SD card  | ~6-8s wall-clock  | Firmware phase dominates
NVMe     | ~5-7s wall-clock  | Firmware phase shorter

## Optimization Stages

Stage 1 - Userspace: custom init, strip packages, qmlcachegen, lean QML
Stage 2 - Kernel: config trimming, disable unused drivers
Stage 3 - Firmware: config.txt levers (boot_delay=0 etc.)
Stage 4 - Hardware: NVMe upgrade after stages 1-3 exhausted
