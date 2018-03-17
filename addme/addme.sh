#!/bin/bash

function invoer {
  # Create Forum
  _input=$(zenity --forms --title="Create user" --text="Add new user" \
     --add-entry="First Name" \
     --add-entry="Last Name" \
     --add-entry="Username" \
     --add-password="Password" \
     --add-password="Confirm Password" \
     #--add-calendar="Expires"
     )

  # Cancel or OK response
  case $? in
    0) check
    ;;
    1) echo "Canceled..."; exit 1
    ;;
    *) echo "Invalid input detected"
    ;;
  esac

}

function check {
  # Set input
  _fname=$(echo $_input | cut -d '|' -f1)
  _lname=$(echo $_input | cut -d '|' -f2)
  _usr=$(echo $_input | cut -d '|' -f3)
  _pwd1=$(echo $_input | cut -d '|' -f4)
  _pwd2=$(echo $_input | cut -d '|' -f5)
  #_exp=$(echo $_input | cut -d '|' -f6)


  # Check if passwords match
  if ! [ $_pwd1 == $_pwd2 ]; then
    zenity --error --title "ERROR" --text "Passwords do not match"
    invoer
  else
    zenity --info --title "Information" --text "User succesfully added (Not really)"
    result
  fi
}

function result {
  # Echo the input result
  echo -e "\e[1;34mUser added\e[0m"
  echo "    First Name  : $_fname"
  echo "    Last Name   : $_lname"
  echo "    Username    : $_usr"
  echo "    Password    : *******"
  #echo "    Expires     : $_exp"

}

invoer
