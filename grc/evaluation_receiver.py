#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: IEEE 802.15.4 Receiver
# GNU Radio version: 3.8.5.0

import os
import sys
sys.path.append(os.environ.get('GRC_HIER_PATH', os.path.expanduser('~/.grc_gnuradio')))

from gnuradio import blocks
from gnuradio import gr
from gnuradio.filter import firdes
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import uhd
import time
from ieee802_15_4_oqpsk_phy_recv import ieee802_15_4_oqpsk_phy_recv  # grc-generated hier_block


class evaluation_receiver(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "IEEE 802.15.4 Receiver")

        ##################################################
        # Variables
        ##################################################
        self.gain = gain = 0.9
        self.freq = freq = 2470e6

        ##################################################
        # Blocks
        ##################################################
        self.uhd_usrp_source_0 = uhd.usrp_source(
            ",".join(('serial=3180E09', "")),
            uhd.stream_args(
                cpu_format="fc32",
                args='',
                channels=list(range(0,1)),
            ),
        )
        self.uhd_usrp_source_0.set_center_freq(freq, 0)
        self.uhd_usrp_source_0.set_normalized_gain(gain, 0)
        self.uhd_usrp_source_0.set_bandwidth(2000000, 0)
        self.uhd_usrp_source_0.set_samp_rate(4000000)
        self.uhd_usrp_source_0.set_time_unknown_pps(uhd.time_spec())
        self.ieee802_15_4_oqpsk_phy_recv_0 = ieee802_15_4_oqpsk_phy_recv()
        self.blocks_file_sink_1 = blocks.file_sink(gr.sizeof_gr_complex*1, '/Users/colinkater/Documents/Uni/Master/FSS22/MasterArbeit/sdr-jrb/raw/raw.raw', False)
        self.blocks_file_sink_1.set_unbuffered(False)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.uhd_usrp_source_0, 0), (self.blocks_file_sink_1, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.ieee802_15_4_oqpsk_phy_recv_0, 0))


    def get_gain(self):
        return self.gain

    def set_gain(self, gain):
        self.gain = gain
        self.uhd_usrp_source_0.set_normalized_gain(self.gain, 0)

    def get_freq(self):
        return self.freq

    def set_freq(self, freq):
        self.freq = freq
        self.uhd_usrp_source_0.set_center_freq(self.freq, 0)





def main(top_block_cls=evaluation_receiver, options=None):
    if gr.enable_realtime_scheduling() != gr.RT_OK:
        print("Error: failed to enable real-time scheduling.")
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    try:
        input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
