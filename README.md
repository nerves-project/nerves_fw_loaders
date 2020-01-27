# Nerves Firmware Loaders

This project contains simple first-time firmware loaders for installing Nerves
firmware (or other code) on internal device storage. Target devices usually have
eMMC memory but can boot off removable media like a USB flash drive or SD card.
Code from this project would be put on the removable media, run once to program
the eMMC, and then from that point onward, the device would boot off the eMMC.

Devices with internal storage generally have more than one way of bootstrapping
that storage. This mechanism is intended to be simple for one-offs and low
volume builds. If you're building a lot of devices, you'll want to investigate
other methods like preprogramming eMMC parts or integrating programming with a
manufacturing test fixture.

See the device-specific notes for variations, but here's how this project
generally works:

1. Download the firmware loader for your board (or modify an existing one)
2. Program a USB flash drive (or SD Card) with the firmware
3. Mount the flash drive on your computer and copy the firmware file that you
   want to load onto the device to it
4. Plug the flash drive into the device and power it on
5. Watch the device boot. Status can be seen either by looking at the debug
   console or LEDs on the board.
6. When complete, remove the flash drive
7. The device will boot the new firmware

## Creating the loader media

First, find your device and download or build the firmware. This project uses
[`fwup`](https://github.com/fhunleth/fwup) for writing images to media, but
plain binaries can be made too if that works better for your work.

On your computer, insert either a USB flash drive or SD Card (or whatever is the
right media for booting the loader off of for your device). Then run `fwup`:

```sh
$ fwup my_loader.fw
Use 7.75 GB memory card found at /dev/sdc? [y/N] y
|====================================| 100% (9.27 / 9.27) MB
Success!
Elapsed time: 1.432 s
```

Replace `my_loader.fw` with appropriate path for your loader. If you built your
own loader, the `.fw` file is in Buildroot's `images` subdirectory.

Next, copy your device's firmware to the `LOADER` partition on the removable
media. You may need to re-insert the device in your computer for the `LOADER`
partition to appear.

On Linux, this looks something like this at the commandline:

```sh
cp my_firmware.fw /media/fhunleth/LOADER/loader.fw
```

On Mac, the `LOADER` partition won't appear, but `mtools` can do the copy:

```sh
$ brew install mtools

# Figure out which drive to use
$ fwup -D
/dev/rdisk2,7748222976

# The drive is /dev/rdisk2. The `LOADER` partition is the second one, so
# append an `s2` to whatever you get. Also remove the `r` so that mtools
# use cached (rather than raw) access to the drive. In this example,
# we're using `/dev/disk2s2`.

# Check that we have the right drive
$ sudo mdir -i /dev/disk2s2
 Volume in drive : is LOADER
 Volume Serial Number is 0021-0000
Directory for ::/

readme   txt        67 1980-01-01   0:00
        2 files                  67 bytes
                        452 760 576 bytes free

# Copy the firmware
$ sudo mcopy -i /dev/disk2s2 my_firmware.fw ::install.fw

# Check that it worked:

$ sudo mdir -i /dev/disk2s2
 Volume in drive : is LOADER
 Volume Serial Number is 0021-0000
Directory for ::/

readme   txt        67 1980-01-01   0:00
INSTALL  FW   43857509 2020-01-23   0:50  install.fw
        2 files          43 857 576 bytes
                        452 760 576 bytes free
```

## Supported devices

The nature of this project is that once a loader is created and works, people tend to go with it and not change it. The hope is that these loaders are simple
enough that they do not require much maintenance. They're provided as an aide.
If you make a loader using this repository, please consider contributing it back
for others.

* [UP Board (x86_64)](https://github.com/fhunleth/nerves_fw_loaders/blob/master/board/up_board/README.md)
* [OnLogic CL (x86_64)](https://github.com/fhunleth/nerves_fw_loaders/blob/master/board/onlogic_cl210/README.md)

## Customizing

The default images can be customized by adding an `install.sh` script to the
data partition. If an `install.sh` script is found, the loader runs it instead
of its normal processing. If the script returns successfully, the board will be
rebooted, but if not, it will report an error and hang.

## License

The project would not exist without Buildroot and follows the GPL like
Buildroot. Like Buildroot, this applies to the scripts and recipes for building
projects here. The code that runs on the device is covered by other licenses.
