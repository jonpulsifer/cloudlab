# homepi4

Raspberry Pi 4 with the [Raspberry Pi Touch Display](https://www.buyapi.ca/product/smartipi-touch-2-case-for-7-official-display/) in the [SmartiPi Touch 2](https://smarticase.com/collections/smartipi-touch-2/products/smartipi-touch-2) case.

## Installation

1. Image Ubuntu Server 20.04.1 LTS onto a MicroSD card
   1. <https://ubuntu.com/download/raspberry-pi>
   2. Copy `cmdline.txt` and `network-config` and `user-data` into `/boot` after imaging (you may have to eject and re-insert the MicroSD card)
2. :moneybag:

## Kiosk

The default service starts `chromium` in kiosk mode as the kiosk user.
