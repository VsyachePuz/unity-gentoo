# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The D-Bus module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
:
fi

IUSE=""

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=sys-apps/dbus-1.4.20
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/dbus
	src/tools/qdbusxml2cpp
	src/tools/qdbuscpp2xml
)

QT5_GENTOO_CONFIG=(
	:dbus
	:dbus-linked:
)

src_configure() {
	local myconf=(
		-dbus-linked
	)
	qt5-build_src_configure
}
