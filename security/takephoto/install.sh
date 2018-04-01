#!/bin/bash
# This script can be expended with a email script.
# Simply change the settings in the script

function checkroot {
  if [ $(id -u) == 0 ]; then
    createfile
  else
    echo -e "\e[31m[ERROR]\e[0m Please, use sudo"
  fi
}

function createfile {
  if [ -e /usr/bin/takephoto ]; then
    echo -e "\e[31m[ERROR]\e[0m /usr/bin/takephoto exists, exiting..."; exit 0
  else
    echo """#!/bin/bash
ts=`date +%d_%m_%Y-%H_%M_%S`
ffmpeg -f video4linux2 -s vga -i /dev/video0 -ss 0:0:3 -vframes 3 /tmp/vid-$ts.%01d.jpg
#avconv -f video4linux2 -s 640x480 -i /dev/video0 -ss 0:0:3 -frames 3 /tmp/vid-$ts.%01d.jpg
exit 0""" >> /usr/bin/takephoto

    chmod +x /usr/bin/takephoto

    echo -e "\e[32m[OK]\e[0m Photos will be saved to /tmp/"
  fi

  common-auth
}


function common-auth {
  cp /etc/pam.d/common-auth /etc/pam.d/common-auth.bak
  _file="/etc/pam.d/common-auth"

  #if [ $(grep -R "success=2" "/etc/pam.d/common-auth") ]; then
  if [[ $(grep -R "success=2" "$_file") ]]; then
    echo -e "\e[32m[OK]\e[0m Already configured"
  else
    sed -i 's/success=.*/success=2 default=ignore]	pam_unix.so nullok_secure/' $_file

    sed -i '18c\auth	[default=ignore]	pam_exec.so seteuid /usr/bin/takephoto\' ./common-auth
    #echo "auth	[default=ignore]	pam_exec.so seteuid /usr/bin/takephoto" >> $_file

    echo -e "\e[32m[OK]\e[0m DONE"
  fi

}

checkroot
