#!/bin/bash

function checkroot {
  if [ $(id -u) == 0 ]; then
    checkpackage
  else
    echo -e "\e[1;31mPlease, use sudo\e[0m"
  fi
}

function checkpackage {
  if [ $(dpkg-query -W -f='${Status}' isc-dhcp-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo -e "\e[31m[MISSING]\e[0m isc-dhcp-server"
      printf "Do you wish to install this package? (y/N) "; read _yn
    if [[ $_yn =~ ^[Yy]$ ]]; then
      apt install isc-dhcp-server -y
    else
      echo -e "\e[31m[ERROR]\e[0m isc-dhcp-server is not installed, exiting..."
      exit 1
    fi
    dhcp
  fi

  dhcp

}

function dhcp {

   #Static Values
  #_subnet="192.168.67.0"
  #_netmask="255.255.255.0"
  #_range="192.168.67.20 192.168.67.250"
  #_ip="192.168.67.1"

  # Rename old file
  mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.old

  # Values
  printf "Subnet (Ex. 192.168.67.0): "; read _subnet
  printf "Netmask (Ex. 255.255.255.0): "; read _netmask
  printf "Range (Ex. 192.168.67.20 192.168.67.250): "; read _range
  printf "Broadcast (Ex. 192.168.67.255): "; read _broadcast
  printf "Default gateway (Ex. 192.168.67.1): "; read _gw


  # DHCP configuration
  echo """
authoritative;

subnet $_subnet netmask $_netmask {
    range $_range;
    option domain-name 'example.com';
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    option broadcast-address $_broadcast;
    option routers $_gw;
      #next-server 192.168.67.20;
  """ >> /etc/dhcp/dhcpd.conf

  sleep 1

  /etc/init.d/isc-dhcp-server restart

  sleep 1

  echo -e "\e[32m[OK]\e[0m DHCP server"

}

checkroot
