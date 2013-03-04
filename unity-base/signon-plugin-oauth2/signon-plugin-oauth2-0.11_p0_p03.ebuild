EAPI=4

inherit base qt4-r2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
URELEASE="quantal"

DESCRIPTION="Single Signon oauth2 plugin used by the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/qjson
	dev-qt/qtcore:4
	unity-base/signon-ui"
DEPEND="${RDEPEND}"

S="${WORKDIR}/signon-oauth2-${PV}"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_install() {
	qt4-r2_src_install

	# Already provided by net-libs/account-plugins with sensible settings #
	rm ${ED}etc/signon-ui/webkit-options.d/www.facebook.com.conf
}
