#!/bin/bash

FAILED_UNITS=$(fleetctl list-units | grep octo- | grep -v octo-master | grep running | awk '{print $1}')

for UNIT in $FAILED_UNITS; do
  echo $UNIT
  fleetctl unload $UNIT
done
