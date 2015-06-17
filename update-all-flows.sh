#!/bin/bash

ALL_UNITS=$(fleetctl list-units | grep octo- | grep -v octo-master | awk '{print $1}')

for UNIT in $ALL_UNITS; do
  echo $UNIT

  printf "stoping:> %s" $UNIT
  fleetctl stop $UNIT

  printf "waiting:> for %s to stop " $UNIT;
  is_running=1
  while [ $is_running -ne 0 ]; do
    is_running=`fleetctl list-units | grep running | grep $UNIT | wc -l`;
    sleep 1;
    printf ".";
  done
  printf "\n"

  printf "starting:> %s\n" $UNIT
  fleetctl start $UNIT

  printf "waiting:> for %s to start " $UNIT;
  while [ $is_running -eq 0 ]; do
    is_running=`fleetctl list-units | grep running | grep $UNIT | wc -l`;
    sleep 1;
    printf ".";
  done
  printf "\n"

  fleetctl list-units | grep $UNIT

done
