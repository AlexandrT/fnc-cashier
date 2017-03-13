#!/bin/bash
for i in $(emulator -list-avds)
do
  emulator -avd ${i}
  rspec spec
done
