# Maintainer:  Alfredo Palhares <masterkorp@masterkorp.net>
# Contributor: Grigory Sokolik <g.sokol99@g-sokol.info>

pkgname=openvpn-update-resolv-conf-git
pkgver=11.dd96841
pkgrel=1
pkgdesc="This is a script to update your /etc/resolv.conf with DNS settings that come from the received push dhcp-options. Since network management is out of OpenVPN client scope, this script adds and removes the provided from those settings. This script was found on the OpenVPN page of the Archlinux Wiki"
arch=('any')
url="https://github.com/masterkorp/openvpn-update-resolv-conf"
license=('GPL')
depends=('openvpn' 'openresolv')
makedepends=('git')
install=openvpn-update-resolv-conf-git.install
source=("$pkgname::git+https://github.com/masterkorp/openvpn-update-resolv-conf.git")
md5sums=('SKIP')

pkgver() {
  cd "$pkgname"
  printf "%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "${srcdir}"
  install -Dm0755 openvpn-update-resolv-conf-git/update-resolv-conf.sh "${pkgdir}/usr/bin/update-resolv-conf.sh"
}

# vim: set ts=2 sw=2 et:
