# blinkypi0

Raspberry Pi Zero W with a [Blinkt!](https://github.com/pimoroni/blinkt) LED board in the [Flirc Raspberry Pi Zero Case
](https://flirc.tv/more/flirc-raspberry-pi-zero-case) case.

## Installation

1. Image Raspberry Pi OS onto a MicroSD card
   1. <https://www.raspberrypi.org/software/operating-systems/> this  guide was built using Raspberry Pi OS Lite
   1. Copy `ssh` and `wpa_supplicant.conf` into `/boot` after imaging
2. Configure Raspberry Pi OS
   1. Change the hostname to `blinkypi0` using `raspi-config`
   1. Change the default passphrase (or prefer SSH keys)
1. Install the Blinkt! python3 library <https://github.com/pimoroni/blinkt> (follow the instructions)
1. Copy `blinky.py` into the $PATH somewhere
   1. `cp -v blinky.py /usr/local/bin/blinky`
1. Install `blinky.service` as a system service
   1. `cp -v blinky.service /etc/systemd/system/`
   1. `systemctl daemon-reload` to pick up the new changes in /etc/systemd
   1. `systemctl enable blinky` to enable blinky on startup
   1. `systemctl start|stop|restart blinky` to interact with the service
1. :moneybag:

## CloudEvents

If you'd like to send instructions to blinkypi0 with cloudevents, follow a similar pattern with `cloudevents.service` and interact with the web service by sending it a cloud event.

```sh
curl -X POST \
    -H "content-type: application/json" \
    -H "ce-specversion: 1.0" \
    -H "ce-source: https://github.com/jonpulsifer/cloudlab/rpi/blinkypi0" \
    -H "ce-type: dev.pulsifer.blinky.request" \
    -H "ce-id: lolpotato-123" \
    -d '{"action":"rainbow"}' \
    http://blinkypi0:3000
```
