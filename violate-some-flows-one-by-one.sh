#!/bin/bash

FLOWS=$(fleetctl list-units | grep octo- | awk '{print $1}')

mkdir -p tmp

for FLOW in $FLOWS; do
  SERVICE_FILE=$(fleetctl cat $FLOW)

  echo "$SERVICE_FILE" | grep ' octoblu/flow-runner' &> /dev/null
  if [ $? -ne 0 ]; then
    echo "skipping $FLOW"
    continue
  fi

  echo "fixing $FLOW"
  echo "$SERVICE_FILE" \
    | sed -e 's/ octoblu\/flow-runner:latest/ --net host quay.io\/octoblu\/flow-runner:latest/' \
    | sed -e 's/ octoblu\/flow-util:entrypoint/ --net host octoblu\/flow-util:entrypoint/' \
    > tmp/$FLOW

  fleetctl stop $FLOW
  fleetctl destroy $FLOW
  fleetctl submit tmp/$FLOW
  fleetctl start $FLOW
done
