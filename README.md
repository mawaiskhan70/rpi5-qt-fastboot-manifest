# rpi5-qt-fastboot-manifest

Orchestration manifest for building a minimum boot time Qt6 QML UI image
for Raspberry Pi 5 using Yocto Scarthgap (5.0 LTS).

## Architecture
- **Display**: Qt6 EGLFS → KMS/DRM direct (no Weston, no X11)
- **Bootloader**: RPi5 EEPROM direct kernel boot (no U-Boot)
- **Yocto release**: Scarthgap 5.0 LTS (supported until April 2028)
- **Layer manager**: kas (declarative YAML, reproducible builds)

## Repos
| Repo | Purpose |
|------|---------|
| [meta-rpi5-qt-fastboot](https://github.com/mawaiskhan70/meta-rpi5-qt-fastboot) | Custom Yocto layer — recipes, kernel config, bbappends |
| [rpi5-qt-fastboot-manifest](https://github.com/mawaiskhan70/rpi5-qt-fastboot-manifest) | This repo — kas YAML, Docker, scripts, docs |

## Quick Start
```bash
# Install kas-container
curl -fsSL https://raw.githubusercontent.com/siemens/kas/refs/heads/master/kas-container \
    -o kas-container && chmod +x kas-container

# Build SD card image
./scripts/build.sh sd

# Flash to SD card
./scripts/flash.sh sd /dev/sdX
```

## Build Targets
| Command | Target |
|---------|--------|
| `./scripts/build.sh sd` | SD card image |
| `./scripts/build.sh nvme` | NVMe image (M.2 HAT+) |
| `./scripts/build.sh sd shell` | Interactive BitBake shell |
| `./scripts/build.sh sd bitbake <recipe>` | Single recipe build |

## Documentation
- [Architecture decisions](docs/architecture.md)
- [Boot time analysis](docs/boot-time-analysis.md)
- [Setup guide](docs/setup.md)
