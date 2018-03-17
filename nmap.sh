#!/bin/bash
# Get domain name
_zenity="/usr/bin/zenity"
_out="/tmp/nmap.output.$$"
_target=$(${_zenity} --title  "Enter domain" \
	            --entry --text "Enter the domain for nmap scan" )

if [ $? -eq 0 ]; then
  # Display a progress dialog while searching whois database
  nmap -T4 $_target | tee >(${_zenity} --width=200 --height=100 \
  				    --title="Scanning.." --progress \
			        --pulsate --text="Scanning $_target..." \
              --auto-kill --auto-close \
              --percentage=10) >${_out}

  # Display back output
  ${_zenity} --width=800 --height=600  \
	     --title "Whois info for $_target" \
	     --text-info --filename="${_out}"
else
  ${_zenity} --error \
	     --text="No input provided"
fi
