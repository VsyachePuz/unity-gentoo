# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="yes"

URELEASE="vivid"
inherit base eutils multilib multilib-minimal ubuntu-versionator

UURL="mirror://ubuntu/pool/main/a/${PN}"
UVER_PREFIX="2"

DESCRIPTION="Android Platform Headers from AOSP releases"
HOMEPAGE="https://source.android.com/"
SRC_URI="${UURL}/${MY_P}-${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}-${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}-${UVER_PREFIX}"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install(){
	insinto /usr/include/android
	doins -r *

	multilib_src_install() {
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins "${WORKDIR}/debian/android-headers.pc"
	}
	multilib_foreach_abi multilib_src_install
}