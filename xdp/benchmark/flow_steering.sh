#!/bin/bash

# Define the base command
SRC_ADDR="10.7.0.7"
DST_ADDR="10.7.0.6"

BASE_COMMAND="sudo ethtool --config-ntuple enp59s0f1np1 flow-type tcp4 src-ip $SRC_ADDR dst-ip $DST_ADDR"

# Loop 40 times
for i in {0..39}; do
  SRC_PORT=$i
  ACTION=$i
  COMMAND="$BASE_COMMAND src-port $SRC_PORT dst-port 123 action $ACTION"
  echo "Executing: $COMMAND"
  $COMMAND
done