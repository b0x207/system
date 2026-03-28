#!/bin/bash

workspace=$(rofi -dmenu -p "Enter a workspace number" -lines 0 -separator-style "none")
hyprctl dispatch workspace "$workspace"
