# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+14.04.${PVR_MICRO}"
UVER_SUFFIX="~gcc5.1"

DESCRIPTION="Allow applications to export actions in various forms to the Unity Shell"
HOMEPAGE="https://launchpad.net/unity-action-api"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	unity-base/hud"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
export QT_SELECT=5
