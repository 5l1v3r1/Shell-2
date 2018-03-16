#!/bin/bash
_zenity="/usr/bin/zenity"

function checkroot {
  if [ $(id -u) = 0 ]; then
    echo '[OK] root'
    move_file
  else
    zenity --error --title 'ERROR' --text 'NEED ROOT'
  fi
}

function move_file {
  if [ -a /usr/bin/backup_home ]; then
    rm /usr/bin/backup_home
    zenity --info --title "Information" --text "Command deleted"

  else
    cp backup.sh /usr/bin/backup_home
    zenity --info --title "Information" --text "Command moved"
  fi
}

checkroot
