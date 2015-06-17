#!/bin/bash

INACTIVE_FLOWS=$(fleetctl list-unit-files | grep octo- | grep -v octo-master | grep inactive | awk '{print $1}')

for UNIT in $INACTIVE_FLOWS; do
  echo $UNIT
  fleetctl start $UNIT
done
