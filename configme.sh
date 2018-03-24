#!/bin/bash

function checkroot {
  if [ $(id -u) == 0 ]; then
    checkpackages
  else
    echo -e "\e[1;31mPlease, use sudo\e[0m"
  fi
}

function atom {
  wget https://atom.io/download/deb -P /tmp/ -q
  dpkg -i /tmp/atom-amd64.deb

  rm /tmp/atom-amd64.deb
}

function skype {
  wget https://go.skype.com/skypeforlinux-64.deb -P /tmp/ -q
  dpkg -i /tmp/skypeforlinux-64.deb
  rm /tmp/skypeforlinux-64.deb

}

function stacer {
  # Grab link
  _link=$(lynx --dump --listonly https://github.com/oguzhaninan/Stacer/releases | grep _amd64.deb | \
          cut -f2- -d'.' | sed ${1}q;)

  # Grab file
  _file=$(echo "$_link" | cut -d "/" -f9)

  # Download file
  wget $_link -P /tmp/ -q

  # Install file
  dpkg -i /tmp/$_file

  # Remove file
  rm /tmp/$_file

}

function artillery {

  if [ -d /var/artillery ]; then
    echo -e "\e[32m[OK]\e[0m artillery"
  else
    echo -e "\e[31m[MISSING]\e[0m artillery"

    printf "Do you wish to install this now? (y/N) "; read _yn
    if [[ $_yn =~ ^[Yy]$ ]]; then
      echo -e "\e[32mInstalling\e[0m artillery"

      # Download
      git clone https://github.com/BinaryDefense/artillery.git

      # Install
      python artillery/setup.py

      # Cleaning up
      rm -rf artillery
    fi
  fi

  accountservice

}

function accountservice {
  # Set a user as System user to hide it from GDM

  printf "Set SystemAccount for username: "; read _usr

  if [ $_usr == "" ]; then
    echo -e "\e[31m[ERROR]\e[0m No username given, exiting..."; exit 1
  else

    if [ $(grep -R "SystemAccount=true" "/var/lib/AccountsService/users/$_usr") ]; then
      echo -e "\e[32m[OK]\e[0m $_usr already a system user"
    else
      sed -i 's/SystemAccount.*/SystemAccount=true/' /var/lib/AccountsService/users/$_usr
      echo -e "\e[32m[OK]\e[0m SystemAccount for user $_usr"
    fi
  fi

}


function checkpackages {
    # Missing packages: Anydesk

  # Packages to check
  _packages=("keepass2" "xdotool" "lynx" "git" "libreoffice-l10n-nl" "ettercap-graphical" "mc" "myspell-nl" "vokoscreen" \
        "vlc" "virtualbox" "thunderbird" "corebird" "chromium-browser" "wireshark" "atom" "skypeforlinux" \
        "glances" "gparted" "gimp" "recon-ng" "nmap" "net-tools" "arp-scan" "tilix" "stacer" )

  # For item in list, check if installed
  #   if not >> ask to install
  for item in ${_packages[*]}
  do
    if [ $(dpkg-query -W -f='${Status}' $item 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
      echo -e "\e[31m[MISSING]\e[0m $item"
        printf "Do you wish to install this now? (y/N) "; read _yn
      if [[ $_yn =~ ^[Yy]$ ]]; then
        echo -e "\e[32mInstalling\e[0m $item"

        # For webmin, be special
        if [ $item == "atom" ]; then
          atom
        elif [ $item == "skypeforlinux" ]; then
          skype
        elif [ $item == "stacer" ]; then
          stacer
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

  artillery

}

checkroot
