#!/bin/bash

function checkroot {
  if [ $(id -u) = 0 ]; then
    echo '[OK] root'
    move_file
  else
    zenity --error --title 'ERROR' --text 'NEED ROOT'
  fi
}

function move_file {
  if [ -a /usr/bin/addme ]; then
    rm /usr/bin/addme
    zenity --info --title "Information" --text "Command deleted"

  else
    cp addme.sh /usr/bin/addme
    zenity --info --title "Information" --text "Command moved"
  fi
}

checkroot
