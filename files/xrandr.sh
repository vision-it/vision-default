#!/usr/bin/env bash

# Script to automatically configure the resolution / monitor setup of desktops PCs
# Please edit (and push) when necessary

case $(hostname) in
    "ux1104")
        xrandr --auto --output 'HDMI-1' --mode '1920x1200' --left-of 'VGA-1' --output 'VGA-1' --mode '1600x1200'
        ;;
    "ux1224")
        xrandr --auto --output 'DVI-I-1' --mode '1920x1200' --left-of 'VGA-1' --output 'VGA-1' --mode '1680x1050'
        ;;
    "ux1402")
        # landscape
        #xrandr --auto --output 'DP1' --mode '1920x1200' --output 'HDMI2' --right-of 'DP1' --mode '1600x1200'
        # portrait
        xrandr --auto --output DP1 --mode 1920x1200 --rotate left \
            --output HDMI2 --right-of DP1 --mode 1680x1050 --rotate left
        ;;
    "ux1105")
        xrandr --auto --output 'DVI-I-1' --mode '1920x1200' --left-of 'HDMI-1' --mode '1920x1200'
        ;;
    "ux1479")
        xrandr --output 'DVI-I-1' --auto --left-of 'VGA-1'
        ;;
    *)
        echo "Sorry, no setup found. Please edit $0";
        exit 1;
        ;;
esac
