#!/bin/bash
logfile="./log/log_$1.log"
test_name="$2"

filename_csv="./log/tests/data.csv"
filename="./log/tests/test_$1_$test_name"
filename_log="$filename.log"
filename_bytes="$filename.bytes"
filename_frameno="$filename.frameno"
filename_report="$filename.report"
filename_raw="$filename.raw"

echo "Creating report for run $test_name"

cat $logfile | grep RX | grep "0x00 0x00 0x00 0x00 0xa7 0x21 0x41" > $filename_bytes
cat $logfile | grep "MISSING:" > $filename_frameno

missing_packet_count=$(cat ${filename_frameno} | awk -F '\:' '{print $2}' | awk '{ sum += $1 } END { print sum }')
lines_count=$(cat ${filename_bytes} | wc -l)

expected_byte_count=$((6000 * 39))
actual_byte_count=$(cat ${filename_bytes}| cut -d' ' -f2 | sed 's/^.//' | sed 's/.$//' | awk '{s+=$1} END {print s}')

calc(){ awk "BEGIN { print "$*" }"; }

byte_received_rate=$(calc $actual_byte_count/$expected_byte_count)
byte_jammed_rate=$(calc 1-$byte_received_rate)

packets_unjammed=$(cat $filename_bytes | grep '\[39\]' | wc -l | xargs)
packets_jammed=$(($lines_count - $packets_unjammed))

echo "Test Run:   $test_name" > $filename_report
echo "Timestamp:  $1" >> $filename_report
echo "" >> $filename_report

echo "byte_received_expected:  ${expected_byte_count}" >> $filename_report
echo "byte_received_actual:    ${actual_byte_count}" >> $filename_report


echo "byte_pass_rate:          ${byte_received_rate}" >> $filename_report
echo "byte_lost_rate:          ${byte_jammed_rate}" >> $filename_report
echo "" >> $filename_report

lines_count_x=$(($lines_count * 1))
echo "packets:              ${lines_count_x}" >> $filename_report
echo "packets_missing:      ${missing_packet_count}" >> $filename_report

echo "$2,$1,${expected_byte_count},${actual_byte_count},${lines_count_x},${missing_packet_count},${packets_unjammed}" >> $filename_csv

if [[ "$packets_unjammed" == 0 ]]; then
echo "All packets were affected!" >> $filename_report
else 

packets_pass_rate=$(calc $packets_unjammed/$lines_count_x)
packets_jam_rate=$(calc 1-$packets_pass_rate)

echo "packets_uncorrupted:  ${packets_unjammed}" >> $filename_report
echo "packets_corrupted:    ${packets_jammed}" >> $filename_report
echo "packets_pass_rate:    ${packets_pass_rate}" >> $filename_report
echo "packets_jam_rate:     ${packets_jam_rate}" >> $filename_report
fi
# mv raw/raw.raw $filename_raw
mv $logfile $filename_log
code $filename_report 
