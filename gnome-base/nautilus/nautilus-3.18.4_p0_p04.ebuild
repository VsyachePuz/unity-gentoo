# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

URELEASE="xenial"
inherit autotools base eutils gnome2 readme.gentoo virtualx ubuntu-versionator

UURL="mirror://unity/pool/main/n/${PN}"
UVER_PREFIX=".is.3.14.3"

DESCRIPTION="A file manager for the GNOME desktop patched for the Unity desktop"
HOMEPAGE="http://live.gnome.org/Nautilus"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
# profiling?
IUSE="debug exif gnome +introspection packagekit +previewer sendto tracker xmp"
KEYWORDS="~amd64 ~x86"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
RESTRICT="mirror test"

# FIXME: selinux support is automagic
# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=dev-libs/glib-2.35.3:2=
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.13.2:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	dev-libs/libunity

	gnome-base/dconf
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	>=x11-libs/libnotify-0.7:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	tracker? ( >=app-misc/tracker-0.16:= )
	xmp? ( >=media-libs/exempi-2.1.0 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.33
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto
	dev-libs/libzeitgeist"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )"

# For eautoreconf
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am"

PDEPEND="
	gnome? (
		>=x11-themes/gnome-icon-theme-1.1.91
		x11-themes/gnome-icon-theme-symbolic )
	tracker? ( >=gnome-extra/nautilus-tracker-tags-0.12 )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk]"
# Need gvfs[gtk] for recent:/// support

S="${WORKDIR}/${PN}-3.14.3"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf

	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi

	# Restore the nautilus-2.x Delete shortcut (Ctrl+Delete will still work);
	# bug #393663
#	epatch "${FILESDIR}/${PN}-3.5.91-delete.patch"	# Disabled as handled by Ubuntu's '14_bring_del_instead_ctrl_del.patch'

	# Remove -D*DEPRECATED flags. Don't leave this for eclass! (bug #448822)
	sed -e 's/DISABLE_DEPRECATED_CFLAGS=.*/DISABLE_DEPRECATED_CFLAGS=/' \
		-i configure || die "sed failed"
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS HACKING MAINTAINERS NEWS README* THANKS"
	gnome2_src_configure \
		--disable-profiling \
		--disable-update-mimedb \
		$(use_enable debug) \
		$(use_enable exif libexif) \
		$(use_enable introspection) \
		$(use_enable packagekit) \
		$(use_enable sendto nst-extension) \
		$(use_enable tracker) \
		$(use_enable xmp)
}

src_test() {
	gnome2_environment_reset
	unset DBUS_SESSION_BUS_ADDRESS
	export GSETTINGS_BACKEND="memory"
	Xemake check
	unset GSETTINGS_BACKEND
}

src_install() {
	use previewer && readme.gentoo_create_doc
	gnome2_src_install

	insinto /usr/share/applications/
	doins "${WORKDIR}"/debian/*.desktop
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi

	ubuntu-versionator_pkg_postinst
}
