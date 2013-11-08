ActsAsBeacon
============

### Overview

This app enables an iOS7 device to be configured as a Bluetooth LE beacon as an alternative to faffing around with beacon hardware such as Redbear Labs' BLE Mini boards.

### How to use

To set up the device as a beacon, select the `Beacon` tab and set the `major` and `minor` settings to the value of your choice.  Advertising can be controlled with the `Start/Stop advertising` buttons

To use the device as a beacon client, select the `Client` tab and tap the `Start/Stop seeking` button.
Visible beacons will be displayed with major, minor, proximity, accuracy and signal strength values.

### Limitations

The UUID value is currently hard-coded to `dae137d2-48a7-11e3-b6c8-ce3f5508acd9`

### Future enhancements

1. Add the ability to alter the hard-coded UUID value.