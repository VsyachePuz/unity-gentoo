# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT5_MODULE="qttools"

inherit qt5-build

DESCRIPTION="Interface to Qt applications communicating over D-Bus"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
:
fi

IUSE=""

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdbus-${PV}:5
	>=dev-qt/qtxml-${PV}:5
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdbus/qdbus
)
