#! /bin/bash

while true
do
    ! pidof hyprlock || hyprctl dispatch dpms off
    sleep 30
done
