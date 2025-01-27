# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="xenial"
inherit distutils-r1 eutils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+14.04.20140318"

DESCRIPTION="Photo lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-photos"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Let people emerge this by default, bug #472932
IUSE+=" +python_single_target_python3_4 python_single_target_python3_5"

RESTRICT="mirror"

RDEPEND="dev-libs/dee[${PYTHON_USEDEP}]
	dev-libs/libgee
	net-libs/liboauth
	dev-python/pygobject[${PYTHON_USEDEP}]
	net-libs/libsoup
	net-libs/libsoup-gnome
	dev-libs/libunity[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	media-gfx/shotwell
	net-libs/account-plugins
	unity-base/unity
	unity-base/unity-language-pack
	${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	python_fix_shebang "${ED}"
}
