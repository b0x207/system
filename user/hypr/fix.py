#!/usr/bin/env python

"""
A very simple python script for moving my typical workspaces to the right monitor
"""

import os

TARGET_MONITOR = "HDMI-A-1"
WORKSPACE_RANGE = range(0, 9)

for workspace in WORKSPACE_RANGE:
    c = f"hyprctl dispatch moveworkspacetomonitor {workspace} {TARGET_MONITOR}"
    os.system(c)
