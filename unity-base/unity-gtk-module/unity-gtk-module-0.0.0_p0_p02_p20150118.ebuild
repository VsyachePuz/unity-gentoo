# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="xenial"
inherit autotools eutils python-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+15.04.${PVR_MICRO}"

DESCRIPTION="GTK+ module for exporting old-style menus as GMenuModels"
HOMEPAGE="https://launchpad.net/unity-gtk-module"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libdbusmenu:=[gtk3]
	x11-libs/libX11
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	!x11-misc/appmenu-gtk"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch "${FILESDIR}/unity-gtk-module-0.0.0+14.04-deprecated-api.patch"
	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
		../configure --prefix=/usr \
			--sysconfdir=/etc \
			--disable-static \
			--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
		../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static || die
	popd
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
		emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
		emake || die
	popd
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
		emake DESTDIR="${D}" install || die
	popd

	# Install GTK3 support #
	pushd build-gtk3
		emake DESTDIR="${D}" install || die
	popd

	prune_libtool_files --modules
}
