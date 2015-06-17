#!/bin/bash

ALL_UNITS=$(fleetctl list-units | grep octo- | grep -v octo-master | awk '{print $1}')
UNITS_TO_RESTART=$(echo $ALL_UNITS | wc -w)
INDEX=1
for UNIT in $ALL_UNITS; do
  printf "restarting:> %s\n" $UNIT

  printf "unloading:> %s\n" $UNIT
  fleetctl unload $UNIT

  printf "waiting:> for %s to unload " $UNIT;
  IS_RUNNING=1
  while [ $IS_RUNNING -ne 0 ]; do
    IS_RUNNING=$(fleetctl list-units | grep running | grep $UNIT | wc -l)
    sleep 1;
    printf ".";
  done
  printf "\n"

  printf "starting:> %s\n" $UNIT
  fleetctl start $UNIT

  printf "waiting:> for %s to start " $UNIT;
  while [ $IS_RUNNING -eq 0 ]; do
    IS_RUNNING=$(fleetctl list-units | grep running | grep $UNIT | wc -l)
    sleep 1;
    printf ".";
  done
  printf "\n"

  fleetctl list-units | grep $UNIT

  printf "done restarting %d out of %d\n" $INDEX $UNITS_TO_RESTART
  let INDEX++
done
