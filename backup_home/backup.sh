#!/bin/bash
_zenity="/usr/bin/zenity"

function setpasswd {
  zenity --question --title "Encrypt?" --text "Would you like to set a password?" --width "200" height "100"
  case $? in
    0) echo "Set password"; encrypted_compress
    ;;
    1) echo "No password, compressing..."; compress
    ;;
    *) echo "Canceled..."; exit 0
    ;;
  esac
}

function compress {
  # Compressing
  zip $_dst/backup_$_date.zip $_src* | ${_zenity} --width=200 height=100 --progress --pulsate \
        --text="Compressing Files" --auto-close --percentage=10

}

function encrypted_compress {
  _passwd=$(zenity --password); zip -P $_passwd $_dst/backup_$_date.zip $_src* | ${_zenity} --width=200 height=100 --progress --pulsate \
        --text="Compressing Files" --auto-close --percentage=10
}

_date=`date +%Y-%m-%d`

# Select source
#_src=$(zenity --file-selection --directory --title "Select directory to back-up")
#echo $_src

# Static source
# ( !! unhash the above lines and hash these to select a source !!)
_src="/home/$USER/"

# Select Destination
#_dst=$(zenity --file-selection --directory --title "Select back-up location")

# Static destination
_dst="/home/$USER/"

echo $_dst

setpasswd
