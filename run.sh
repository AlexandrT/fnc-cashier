#!/bin/bash

cd /root/www/fnc-cashier
source ~/.bash_profile

appium > /var/log/tests/appium.log 2>&1 &

emulator64-arm -avd test -no-boot-anim -noaudio -no-window -verbose -qemu > /var/log/tests/emulator.log 2>&1 &
adb wait-for-device

source ~/.bash_profile && rspec spec --out /var/log/tests/tests.log --format documentation
