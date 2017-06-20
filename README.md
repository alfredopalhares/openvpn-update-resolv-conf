OpenVPN Update resolvconf
-------------------------

### Description

This is a script to update your /etc/resolv.conf with DNS settings that
come from the received push dhcp-options. Since network management is out
of OpenVPN client scope, this script adds and removes the provided from
those settings.

This script was found on the [OpenVPN page of the Archlinux Wiki](https://wiki.archlinux.org/index.php/Openvpn#DNS)

However if you have systemd 229 or newer the better option is to use
script from https://github.com/jonathanio/update-systemd-resolved
which uses DBus calls instead of creating temporary *.network files.

### Usage

Install [openresolv](http://roy.marples.name/projects/openresolv)

Place the script in ``/etc/openvpn/update-resolv-conf.sh`` or anywhere the
OpenVPN client can acess.

Add the following lines to your client configuration:

```
# This updates the resolvconf with dns settings
setenv PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
script-security 2
up /etc/openvpn/update-resolv-conf.sh
down /etc/openvpn/update-resolv-conf.sh
down-pre
```

Just start your openvpn client with the command you used to do.

Alternatively, if you don't want to edit your client configuration, you can add the following options to your openvpn command:

```
--setenv PATH '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' --script-security 2 --up /etc/openvpn/update-resolv-conf.sh --down /etc/openvpn/update-resolv-conf.sh --down-pre
```

### Support

For bugs and another questions open a ticket in the [Isssues Page](https://github.com/masterkorp/openvpn-update-resolv-conf/issues).

You can find me on irc.freenode.org and in last case mail me through the email that is on my [Github Profile](https://github.com/masterkorp)

### License

Licenced under GNU GPL.

### Credits

2016 - WGH Added modified script to support systemd-networkd

2014 - Alfredo Palhares <masterkorp@masterkorp.net>

2013 - colin@daedrum.net Fixed intet name

2006 - chlauber@bnc.ch
