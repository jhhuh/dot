#!/bin/sh

play -t sl -r48000 -c2 - synth -1 pinknoise tremolo .1 40 <  /dev/zero 
