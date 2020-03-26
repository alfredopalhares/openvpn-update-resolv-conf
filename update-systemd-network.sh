#!/bin/bash
#
# Parses DHCP options from OpenVPN and creates a temporary systemd.network
# configuration file with DNS settings, so they will be used by
# systemd-resolved.
#
# To use set as 'up' and 'down' script in your openvpn *.conf:
# up /etc/openvpn/update-systemd-network
# down /etc/openvpn/update-systemd-network
#
# Used snippets of resolvconf script by Thomas Hood <jdthood@yahoo.co.uk>
# and Chris Hanson
# Licensed under the GNU GPL.  See /usr/share/common-licenses/GPL.
# 02/2016 wgh@torlan.ru modified script to include systemd-resolved support
# 07/2013 colin@daedrum.net Fixed intet name
# 05/2006 chlauber@bnc.ch

SYSTEMD_PREFIX=/run/systemd

if [ ! -d "$SYSTEMD_PREFIX" ]; then
    echo "$SYSTEMD_PREFIX doesn't exist" >&2
    exit 1
fi

mkdir -p "${SYSTEMD_PREFIX}/network"

IFNAME=$1

NETWORK_FILE="${SYSTEMD_PREFIX}/network/openvpn_${IFNAME}.network"

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

  rm -f $NETWORK_FILE

  (
    echo '[Match]'
    echo "Name=$IFNAME"
    echo '[Network]'
    for dns in $IF_DNS_NAMESERVERS; do
      echo "DNS=$dns"
    done
    if [[ "$IF_DNS_SEARCH" ]]; then
      echo "Domains=$IF_DNS_SEARCH"
    fi
  ) > $NETWORK_FILE

  systemctl restart systemd-networkd
  ;;
down)
  rm -f $NETWORK_FILE
  systemctl restart systemd-networkd
  ;;
esac
