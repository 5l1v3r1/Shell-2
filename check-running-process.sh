#!/bin/bash
_zenity="/usr/bin/zenity"

_process=$(${_zenity} --title  "Enter Process" --entry --text "Please enter a process name" )


ps_out=`ps -ef | grep $_process | grep -v 'grep' | grep -v $0`
result=$(echo $ps_out | grep "$_process")

if [[ "$result" != "" ]];then
    echo "Running"
    ${_zenity} --info --title "$1" --text "Running" --width "100" --height "50"
else
    echo "Not Running"
    ${_zenity} --error --title "Process: $1" --text "Not Running" --width "100" --height "50"
fi
