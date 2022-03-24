#!/bin/bash
#
# Parses DHCP options from OpenVPN and calls systemd-resolved
# configuration file with DNS settings, so they will be used by
# systemd-resolved.
#
# To use set as 'up' script in your openvpn *.conf:
# up /etc/openvpn/update-systemd-reselve.sh



IFNAME=$1

case $script_type in
up)
  for optionname in ${!foreign_option_*} ; do
    option="${!optionname}"
    echo $option >&2
    part1=$(echo "$option" | cut -d " " -f 1)
    if [ "$part1" == "dhcp-option" ] ; then
      part2=$(echo "$option" | cut -d " " -f 2)
      part3=$(echo "$option" | cut -d " " -f 3)
      if [ "$part2" == "DNS" ] ; then
        IF_DNS_NAMESERVERS="$IF_DNS_NAMESERVERS $part3"
      fi
      if [[ "$part2" == "DOMAIN" || "$part2" == "DOMAIN-SEARCH" ]] ; then
        IF_DNS_SEARCH="$IF_DNS_SEARCH $part3"
      fi
    fi
  done

  echo "IF_DNS_NAMESERVERS=$IF_DNS_NAMESERVERS" >&2
  echo "IF_DNS_SEARCH=$IF_DNS_SEARCH" >&2

  DNS=""
  for dns in $IF_DNS_NAMESERVERS; do
    DNS="$DNS --set-dns=$dns"
  done
  echo "$DNS"
  DOMAIN=""
  for domain in $IF_DNS_SEARCH; do
    DOMAIN="$DOMAIN --set-domain=~$domain"
  done
  echo "$DOMAIN"
  
  /usr/bin/systemd-resolve -i ${IFNAME} $DNS $DOMAIN

  ;;
esac
