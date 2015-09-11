#!/bin/bash


FLOWS=$(fleetctl list-units | grep octo- | awk '{print $1}')

for FLOW in $FLOWS; do
  echo $FLOW
  fleetctl stop $FLOW
  fleetctl start $FLOW
done
