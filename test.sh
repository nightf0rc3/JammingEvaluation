#!/bin/bash

# current timestamp
timestamp=$(date +%s)

# total packets sent in 1K packets
packet_num=6
# interval in wich packets are sent in ms
packet_rate=10

expected_time=$(($packet_num * $packet_rate))

# time it takes for the receiver to be ready to receive packets
receiver_startup_time=12

duration=$(($expected_time + 10))
name="${packet_num}K_${packet_rate}ms_$1"

echo "Starting test run: $name"

echo "Starting receiver"
/opt/local/bin/python3.9 ./grc/runTest.py --duration ${duration} > ./log/log_${timestamp}.log 2>&1 &
sleep $receiver_startup_time
echo "Activating motes"
curl http://192.168.0.204/relay/0?turn=on
echo "Motes activated"
sleep $duration
echo "Deactivating motes"
curl http://192.168.0.204/relay/0?turn=off
echo "Motes deactivated"
echo "Completed test run: $name"
./reporting.sh $timestamp $name