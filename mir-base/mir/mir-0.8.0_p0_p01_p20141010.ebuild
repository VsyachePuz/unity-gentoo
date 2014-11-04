# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="utopic"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/m/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Mir is a display server technology"
HOMEPAGE="https://launchpad.net/mir/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3 LGPL-3 MIT"
SLOT="0/26"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="<dev-cpp/gflags-2.1
	dev-cpp/glog
	dev-libs/boost:=
	dev-libs/libhybris
	dev-libs/protobuf:=
	dev-util/android-headers
	>=dev-util/lttng-tools-2.1.1[ust]
	dev-util/umockdev
	<media-libs/glm-0.9.5.1
	media-libs/mesa[egl,gbm,gles2,mir]
	>=sys-devel/gcc-4.7.3
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libxkbcommon
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) || \
			( [[ $(gcc-version) == "4.7" && $(gcc-micro-version) -lt 3 ]] ); then
				die "${P} requires an active >=gcc-4.7.3, please consult the output of 'gcc-config -l'"
	fi
}

src_prepare() {
	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to 'append-cppflags -DNDEBUG' #
	export CMAKE_BUILD_TYPE=none
}

src_configure() {
	# Disable gtest discovery tests as does not work #
	#   cmake/src/mir/mir_discover_gtest_tests.cpp:89: std::string {anonymous}::elide_string_left(const string&, std::size_t): Assertion `max_size >= 3' failed #
	local mycmakeargs="${mycmakeargs}
		-DMIR_ENABLE_TESTS=OFF
		-DDISABLE_GTEST_TEST_DISCOVERY=ON"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc HACKING.md README.md COPYING.GPL COPYING.LGPL doc/*.md
}
