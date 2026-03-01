# Alpine Linux Module (KernelSU-based)

Systemless Alpine Linux Mini RootFS module for KernelSU.

## Disclaimer

This project is not affiliated with Alpine Linux or KernelSU.
Use at your own risk.

## Features

- Alpine Linux (aarch64)
- Automatic rootfs extraction
- Auto-mount /dev, /proc, /sys
- OpenSSH auto-install
- Nano auto-install
- Auto-start SSH on boot
- Wi-Fi remote access
- Port: 8022 (default)
- Root login enabled

---

## Requirements

- KernelSU (SukiSU supported)
- aarch64 / arm64 device
- Root access
- Android 12+
- Termux

---

## Installation

1. Install module via KernelSU
2. Reboot device
3. Connect via SSH:

ssh root@PHONE_IP -p 8022

---

## If login fails, set a root password manually:

Terminal Emulation (Termux or Other)

- su
- chroot /data/adb/modules/alpinelinuxmodule/rootfs /bin/su - root
- passwd root

or ADB Shell

- adb shell su -c "chroot /data/adb/modules/alpinelinuxmodule/rootfs passwd root"

---

## Default SSH Configuration


- Port 8022
- PermitRootLogin yes
- PasswordAuthentication yes


---

## Change Root Password

After login:


passwd root


---

## Project Structure


- /data/adb/modules/alpinelinuxmodule/
- ├── module.prop
- ├── service.sh
- ├── rootfs/


---

## Security Notice

- This module enables root SSH access over Wi-Fi.
- Do NOT expose your device to the public internet.
- No default password is set.
- You must configure root password manually.
- For production use, consider SSH key authentication.

---

## License
GPL v2
