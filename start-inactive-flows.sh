#!/bin/bash

FAILED_UNITS=$(fleetctl list-units | grep octo- | grep -v octo-master | grep failed | awk '{print $1}')

for UNIT in $FAILED_UNITS; do
  echo $UNIT
  fleetctl unload $UNIT
done

  # fleetctl start $UNIT
