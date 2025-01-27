# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
WANT_AUTOMAKE=1.12

URELEASE="xenial"
inherit vala autotools eutils flag-o-matic python-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/libs/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="GObject introspection data for the Signon library for the Unity desktop"
HOMEPAGE="https://launchpad.net/libsignon-glib"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-3"
SLOT="0/1.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND="dev-libs/check
	>=dev-libs/glib-2.35.1
	>=dev-libs/gobject-introspection-1.36.0
	dev-util/gdbus-codegen
	unity-base/signon"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	${PYTHON_DEPS}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" || die
	ubuntu-versionator_src_prepare
	vala_src_prepare
	append-cflags -Wno-error
	eautoreconf
}

src_configure() {
	python_copy_sources
	configuration() {
		econf \
			$(use_enable debug) || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake || die
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		rm -rf "${D}usr/doc"
		emake DESTDIR="${ED}" install
	}
	python_foreach_impl run_in_build_dir installation
	prune_libtool_files --modules
}
