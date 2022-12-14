#!/bin/bash

function runHisto() {
  grep "RX \[31\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[32\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[33\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[34\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[35\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[36\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[37\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[38\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX \[39\] 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
  grep "RX .* 0x00 0x00 0x00 0x00 0xa7 0x21 0x41 0x88" *$1*.bytes | wc -l | xargs >> $1.histogram
}
