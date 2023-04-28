# Create bootable USB on MacOS

1. `hdiutil convert -format UDRW -o /path/to/target.img /path/to/source.iso`
2. Insert USB device
3. `diskutil list` to get device `diskutil unmountDisk /dev/diskX` to unmount
4. `sudo dd if=/path/to/target.img of=/dev/rdiskX bs=1m`
5. `diskutil eject /dev/diskX`