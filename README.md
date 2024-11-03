# NCT6686D Kernel Module

This kernel module permit to recognize the chipset Nuvoton NCT6686D in lm-sensors package.
This sensor is present on some A620 / B650 motherboard such as ASRock.

The implementation is based on https://github.com/Fred78290/nct6687d and in-tree kernel driver
nct6683.

## Features

* Support some newer ASRock AMD motherboards, specifically A620I Lighting WiFi
* Voltage, temperature, fan speed, and PWM value
* Set PWM value
<br><br>

## Installation

### WARNING: I DID NOT TEST DEB OR RPM INSTALL. ONLY MANUAL BUILD IS TESTED.

### via package manager
#### .deb package
- Clone this repository
```shell
~$ git clone https://github.com/s25g5d4/nct6686d
~$ cd nct6686d
```
- Build package
```shell
~$ make deb
```
- Install package
```shell
~$ dpkg -i ../nct6686d-dkms_*.deb
```
<br>

#### .rpm package (akmod)
- Clone this repository
```shell
~$ git clone https://github.com/s25g5d4/nct6686d
~$ cd nct6686d
```
- Build & install package
```shell
~$ make akmod
```
<br><br>

### Manual Install
#### Dependencies:
- Ubuntu/Debian:
	 ```apt-get install build-essential linux-headers-$(uname -r) dkms dh-dkms```
- Fedora/CentOS/RHEL:
	```yum install make automake gcc gcc-c++ kernel-devel kernel-headers dkms```
- ArchLinux:
	 ```pacman -S make automake linux-firmware linux-headers dkms base-devel```
- openSUSE:
	 ```zypper in git make gcc dkms```
<br>

#### Build with DKMS
```shell
~$ git clone https://github.com/s25g5d4/nct6686d
~$ cd nct6686d
~$ make dkms/install
```
<br>

#### Manual build
```shell
~$ git clone (this-repo)
~$ cd nct6686d
~$ make install
```
<br>

## Sensors

By running the command sensors, you got this output

```
nct6686-isa-0a20
Adapter: ISA adapter
VIN0:               1.23 V  (min =  +1.23 V, max =  +1.23 V)
VIN1:             992.00 mV (min =  +0.99 V, max =  +0.99 V)
VIN2:               1.01 V  (min =  +1.01 V, max =  +1.01 V)
VIN3:               1.71 V  (min =  +1.71 V, max =  +1.71 V)
VIN5:               1.25 V  (min =  +1.25 V, max =  +1.26 V)
VIN6:               1.12 V  (min =  +1.12 V, max =  +1.12 V)
VIN7:               1.39 V  (min =  +1.39 V, max =  +1.39 V)
VCC:                3.30 V  (min =  +3.30 V, max =  +3.30 V)
VSB:                3.46 V  (min =  +3.46 V, max =  +3.46 V)
AVSB:               3.46 V  (min =  +3.46 V, max =  +3.46 V)
VTT:                1.81 V  (min =  +1.81 V, max =  +1.81 V)
VBAT:               3.30 V  (min =  +3.30 V, max =  +3.30 V)
VREF:              64.00 mV (min =  +0.06 V, max =  +0.06 V)
fan1:             1518 RPM  (min = 1494 RPM, max = 1518 RPM)
fan2:             1052 RPM  (min = 1024 RPM, max = 1052 RPM)
fan4:             1690 RPM  (min = 1675 RPM, max = 1690 RPM)
Thermistor 16:     +35.0°C  (low  = +33.5°C, high = +35.0°C)
Thermistor 14:     +46.0°C  (low  = +45.5°C, high = +46.0°C)
Thermistor 15:     +48.5°C  (low  = +48.0°C, high = +48.5°C)
AMD TSI Addr 98h:  +58.0°C  (low  = +57.0°C, high = +58.0°C)
intrusion0:       OK
beep_enable:      disabled
```

If you use the same motherboard (ASRock A620I Lighting WiFi) or feeling lucky your motherboard is
somewhat similar, just copy the `sensors.d/A620I-Lighting-WiFi.conf` to `/etc/sensors.d` and you
will get:

```
nct6686-isa-0a20
Adapter: ISA adapter
VCore:           1.23 V  (min =  +1.23 V, max =  +1.23 V)
+5V:             4.96 V  (min =  +4.96 V, max =  +4.96 V)
+12V:           12.10 V  (min = +12.10 V, max = +12.10 V)
VDDCR_SOC:       1.25 V  (min =  +1.25 V, max =  +1.26 V)
VDD_MISC:        1.12 V  (min =  +1.12 V, max =  +1.12 V)
DRAM:            1.39 V  (min =  +1.39 V, max =  +1.39 V)
+3.3V:           3.30 V  (min =  +3.30 V, max =  +3.30 V)
VSB:             3.46 V  (min =  +3.46 V, max =  +3.46 V)
AVSB:            3.46 V  (min =  +3.46 V, max =  +3.46 V)
VTT:             1.81 V  (min =  +1.81 V, max =  +1.81 V)
VBAT:            3.30 V  (min =  +3.30 V, max =  +3.30 V)
VREF:           64.00 mV (min =  +0.06 V, max =  +0.06 V)
fan1:          1501 RPM  (min = 1494 RPM, max = 1518 RPM)
fan2:          1028 RPM  (min = 1024 RPM, max = 1052 RPM)
fan4:          1692 RPM  (min = 1675 RPM, max = 1692 RPM)
Thermistor 16:  +34.5°C  (low  = +33.5°C, high = +35.0°C)
MB:             +46.0°C  (low  = +45.5°C, high = +46.0°C)
Thermistor 15:  +48.5°C  (low  = +48.0°C, high = +48.5°C)
CPU:            +57.0°C  (low  = +57.0°C, high = +58.0°C)
intrusion0:    OK
beep_enable:   disabled
```
<br>

## Load(prob) Sensors on boot

To make it loaded after system boots

Just add nct6686 into /etc/modules

`sudo sh -c 'echo "nct6686" >> /etc/modules'`

### Arch-Linux with systemd

`sudo sh -c 'echo "nct6686" >> /etc/modules-load.d/nct6686.conf'`

<br>

## Tested

This module was tested on PVE 8.2.7 kernel version 6.5.13-6-pve on motherboard
[A620I Lighting WiFi](https://pg.asrock.com/mb/AMD/A620I%20Lightning%20WiFi/index.asp).

<br>

## Other motherboard supported
Currently none.
<br>

## CHANGELOG

- Add support for A620I Lighting WiFi having NCT6686D
- Support giving fan control back to the firmware
<br>

## MODULE PARAMETERS

- **force** (bool) (default: false)
  Set to enable support for unknown vendors.

## CONFIGURATION VIA SYSFS

In order to be able to use this interface you need to know the path as which
it's published. The path isn't fixed and depends on the order in which chips are
registered by the kernel. One way to find it is by device class (`hwmon`) via a
simple command like this:
```
for d in /sys/class/hwmon/*; do echo "$d: $(cat "$d/name")"; done | grep nct6686
```

Possible output:
```
/sys/class/hwmon/hwmon5: nct6686
```

This means that your base path for examples below is `/sys/class/hwmon/hwmon5`
(note that adding/removing hardware can change the path, drop `grep` from the
command above to see all sensors and their relative ordering).

Another way to look it up is by a device (class path actually just points to
device path) like in:

`cd /sys/devices/platform/nct6686.*/hwmon/hwmon*`

The first asterisk will be expanded to an address (`2592` which is `0xa20` that
you can see in `sensors` output) and the second one to a number like `5` from
above.

### `pwm[1-8]`

Gets/sets PWM duty cycle or DC value that defines fan speed.  Which unit is used
depends on what was configured by firmware.

Accepted values: `0`-`255` (slowest to full speed).

Writing to this file changes fan control to manual mode.

Example:

```
# slow down a fan as much as possible (will stop it if the fan supports zero RPM mode)
echo 0 > pwm6
# fix a fan at around half its speed (actual behaviour depends on the fan)
echo 128 > pwm6
# full speed
echo 255 > pwm6
```

### `pwm[1-8]_enable`

Gets/sets controls mode of fan/temperature control.

Accepted values:
 * `1` - manual speed management through `pwm[1-8]`
 * `99` - whatever automatic mode was configured by firmware
          (this is a deliberately weird value to be dropped after adding more
           modes)

Example:

```
# fix a fan at current speed (`echo pwm6` will be constant from now on)
echo 1 > pwm6_enable
# switch back to automatic control set up by firmware (`echo pwm6` is again dynamic after this)
echo 99 > pwm6_enable
# switch to ~25% of max speed
echo 64 > pwm6
# automatic
echo 99 > pwm6_enable
# back to ~25% (it seems to be remembered)
echo 1 > pwm6_enable
```
