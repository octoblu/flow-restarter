#!/bin/bash

FAILED_UNITS=$(fleetctl list-units | grep octo- | grep -v octo-master | grep failed | awk '{print $1}')

fleetctl destroy $FAILED_UNITS
# for UNIT in $FAILED_UNITS; do
#   echo $UNIT
#   fleetctl unload $UNIT
# done
