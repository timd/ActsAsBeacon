ActsAsBeacon
============

### Overview

This app enables an iOS7 device to be configured as a Bluetooth LE beacon as an alternative to faffing around with beacon hardware such as Redbear Labs' BLE Mini boards.

### What's it for?

Making iOS7 devices pretend to be Bluetooth LE beacons for testing purposes.

![Screenshot](https://raw.github.com/timd/ActsAsBeacon/master/screenshot.png)

### How to use

To set up the device as a beacon, select the `Beacon` tab and set the `major` and `minor` settings to the value of your choice.  Advertising can be controlled with the `Start/Stop advertising` buttons

To use the device as a beacon client, select the `Client` tab and tap the `Start/Stop seeking` button.
Visible beacons will be displayed with major, minor, proximity, accuracy and signal strength values.

### Future enhancements

1. Add ability to configure BLE Mini boards over the air (work in progress)
1. Better table layout and moar bling
1. iPad version
1. Err...
1. That's it.