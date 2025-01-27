# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
QT5_MODULE="qtlocation"
inherit qt5-build

DESCRIPTION="Physical position determination library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
:
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

# TODO: src/plugins/position/gypsy
IUSE="geoclue qml"

RDEPEND="
	>=dev-qt/qt3d-5.0:5
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	>=dev-qt/qtmultimedia-${PV}:5
	>=dev-qt/qtnetwork-${PV}:5
	>=dev-qt/qtsvg-${PV}:5
	>=dev-qt/qtxmlpatterns-${PV}:5
	geoclue? (
		app-misc/geoclue:0
		dev-libs/glib:2
	)
	qml? ( >=dev-qt/qtdeclarative-${PV}:5 )
"
DEPEND="${RDEPEND}"

QT5_TARGET_SUBDIRS=(
	src/positioning
	src/plugins/position/positionpoll
)

pkg_setup() {
	use geoclue && QT5_TARGET_SUBDIRS+=(src/plugins/position/geoclue)
	use qml && QT5_TARGET_SUBDIRS+=(src/imports/positioning)
}
