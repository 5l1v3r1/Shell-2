#!/bin/bash

function checkroot {
  if [ $(id -u) == 0 ]; then
    checkpackages
  else
    echo -e "\e[1;31mPlease, use sudo\e[0m"
  fi
}

function webmin {
  # Grab download link
  _link=$(lynx --dump --listonly http://www.webmin.com/download.html \
        | grep http | cut -f2- -d'.' | tr -d ' ' | sort | uniq | grep .deb | sed ${1}q;)

  # Grab filename
  _file=$(echo "$_link" | cut -d '/' -f5)

  echo -e "\e[32mDownloading\e[0m $_link"
  wget $_link -P /tmp/ -q

  echo -e "\e[32mInstalling\e[0m /tmp/$_file"
  apt-get install apt-show-versions libauthen-pam-perl

  dpkg -i /tmp/$_file

  # Remove downloaded file
  rm /tmp/$_file
}

function isc-dhcp-server {
  apt-get install $item -y

   #Static Values
  #_subnet="192.168.67.0"
  #_netmask="255.255.255.0"
  #_range="192.168.67.20 192.168.67.250"
  #_ip="192.168.67.1"


  # Values
  printf "Subnet       (Ex. 192.168.67.0): "; read _subnet
  printf "Netmask      (Ex. 255.255.255.0): "; read _netmask
  printf "Range        (Ex.: 192.168.67.20 192.168.67.250) : "; read _range
  printf "Interface IP (Ex. 192.168.67.1): "; read _ip


  # DHCP configuration
  echo """
authoritative;

subnet $_subnet netmask $_netmask {
    range $_range;
    option domain-name 'example.com';
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    option broadcast-address 192.168.67.255;
    option routers $_ip;
      #next-server 192.168.67.20;
  """ >> ./dhcpd.conf

}

function checkpackages {
  # Packages to check
  _packages=("lynx" "webmin" "isc-dhcp-server" "openssh-server" "openssh-client" "mc" "ntopng" \
        "samba" "lxd" "lxd-client" "quota")

  # For item in list, check if installed
  #   if not >> ask to install
  for item in ${_packages[*]}
  do
    if [ $(dpkg-query -W -f='${Status}' $item 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
      echo -e "\e[31m[ MISSING ]\e[0m $item"
        printf "Do you wish to install this now? (y/N) "; read _yn
      if [[ $_yn =~ ^[Yy]$ ]]; then
        echo -e "\e[32mInstalling\e[0m $item"

        # For webmin, be special
        if [ $item == "webmin" ]; then
          webmin
        elif [ $item == "isc-dhcp-server" ]; then
          isc-dhcp-server
        else
          # Install package
          apt-get install $item -y
        fi
        # Done installing package
        echo -e "\e[32mDone\e[0m $item"
      fi
    else
      # Already installed
      echo -e "\e[32m[OK]\e[0m $item"
    fi
  done

}

checkroot
