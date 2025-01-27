# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit cmake-multilib ubuntu-versionator

UURL="mirror://unity/pool/main/m/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Mir is a display server technology"
HOMEPAGE="https://launchpad.net/mir/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3 LGPL-3 MIT"
SLOT="0/35"	# Taken from /usr/lib/libmirserver.so.*
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="!!media-libs/mesa-mir
	>=dev-cpp/gflags-2.1.2[${MULTILIB_USEDEP}]
	dev-cpp/glog[${MULTILIB_USEDEP}]
	dev-libs/boost:=[${MULTILIB_USEDEP}]
	dev-libs/libhybris[${MULTILIB_USEDEP}]
	dev-libs/libinput[${MULTILIB_USEDEP}]
	dev-libs/protobuf:=[${MULTILIB_USEDEP}]
	dev-util/android-headers[${MULTILIB_USEDEP}]
	dev-util/lttng-tools[ust,${MULTILIB_USEDEP}]
	dev-util/umockdev
	>=media-libs/glm-0.9.5.1
	media-libs/mesa[egl,gbm,gles2,${MULTILIB_USEDEP}]
	virtual/libudev
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	test? ( dev-cpp/gtest )"

S="${WORKDIR}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to 'append-cppflags -DNDEBUG' #
	export CMAKE_BUILD_TYPE=none

	# Disable -Werror #
	sed -e 's:-Werror::g' \
		-i CMakeLists.txt || die

	# Fix libdrm include path #
	#  Source typo(?) /usr/include/drm/drm.h on Ubuntu is a base kernel header, yet other functions in cursor.cpp use libdrm headers #
	sed -e 's:drm/drm.h:drm.h:g' \
		-i src/platforms/mesa/server/kms/cursor.cpp

	cmake-utils_src_prepare
}

multilib_src_configure() {
	# Tell cmake's 'find_library' function to find 32bit versions of libs when we compile for 32bit #
	if [[ ${ABI} == x86 ]]; then
		mycmakeargs+=(-DCMAKE_PREFIX_PATH=/usr/lib32)
	fi

	mycmakeargs+=(-DMIR_ENABLE_TESTS=OFF
		-DMIR_RUN_ACCEPTANCE_TESTS=OFF
		-DMIR_RUN_INTEGRATION_TESTS=OFF
		-DMIR_PLATFORM="mesa-kms;mesa-x11")
	cmake-utils_src_configure
}

multilib_src_install_all() {
	cmake-utils_src_install
	dodoc HACKING.md README.md COPYING.GPL COPYING.LGPL doc/*.md
}
