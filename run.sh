#!/bin/bash

cd /root/www/fnc-cashier
source ~/.bash_profile

appium > /var/log/appium.log 2>&1 &

echo "Starting emulator[$PORT]..."
emulator64-x86 -avd test -noaudio -no-window -gpu off -verbose -qemu -usbdevice tablet & > /var/log/emulator.log 2>&1 &

echo "Tests run..."

source ~/.bash_profile && rspec spec
