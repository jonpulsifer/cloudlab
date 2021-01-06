# radiopi0

Raspberry Pi Zero W in a [Pirate Radio](https://shop.pimoroni.com/products/pirate-radio-pi-zero-w-project-kit) with a [pHAT BEAT](https://shop.pimoroni.com/products/phat-beat) DAC.

## Installation

1. Image Raspberry Pi OS onto a MicroSD card
   1. <https://www.raspberrypi.org/software/operating-systems/> this  guide was built using Raspberry Pi OS Lite
   1. Copy `ssh` and `wpa_supplicant.conf` into `/boot` after imaging
2. Configure Raspberry Pi OS
   1. Change the hostname to `radiopi0` using `raspi-config`
   1. Change the default passphrase (or prefer SSH keys)
1. Install the Blinkt! python3 library <https://github.com/pimoroni/phat-beat> (follow the instructions)
1. Copy `radio.py` into the $PATH somewhere
   1. `cp -v radio.py /usr/local/bin/radio`
1. Install `radio.service` as a system service
   1. `cp -v radio.service /etc/systemd/system/`
   1. `systemctl daemon-reload` to pick up the new changes in /etc/systemd
   1. `systemctl enable radio` to enable radio on startup
   1. `systemctl start|stop|restart radio` to interact with the service
1. :moneybag:

## CloudEvents

If you'd like to send instructions to radiopi0 with cloudevents, follow a similar pattern with `cloudevents.service` and interact with the web service by sending it a cloud event.

```sh
curl -X POST \
    -H "content-type: application/json" \
    -H "ce-specversion: 1.0" \
    -H "ce-source: https://github.com/jonpulsifer/cloudlab/rpi/radiopi0" \
    -H "ce-type: dev.pulsifer.radio.request" \
    -H "ce-id: lolpotato-123" \
    -d '{"url":"https://youtu.be/tfT0i9Qcqn0"}' \
    http://radiopi0:3000
```
