# Copyright 1999-2021 Gentoo Authors and Martin V\"ath
# Distributed under the terms of the GNU General Public License v2

EAPI=7
RESTRICT="mirror"

LUA_COMPAT=( lua5-{3..4} )

inherit desktop flag-o-matic lua-single toolchain-funcs

DESCRIPTION="Drawing editor for creating figures in PDF or PS formats"
HOMEPAGE="http://ipe.otfried.org/"
SRC_URI="https://github.com/otfried/ipe/releases/download/v${PV}/${PN}-${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}
	media-fonts/urw-fonts
	media-gfx/libspiro
	media-libs/freetype:2
	media-libs/libjpeg-turbo
	media-libs/libpng
	sys-libs/zlib
	x11-libs/cairo
	dev-qt/qtcore:5
	dev-qt/qtgui:5"
RDEPEND="${DEPEND}
	|| ( app-text/texlive-core net-misc/curl )"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}/src"

src_prepare() {
	filter-flags -fPIE -pie '-flto*' -fwhole-program -Wl,--no-undefined \
		-DNDEBUG -D_GLIBCXX_ASSERTIONS
	sed -i \
		-e 's/fpic/fPIC/' \
		-e "s'\$(IPEPREFIX)/lib'\$(IPEPREFIX)/$(get_libdir)'g" \
		-e "s'\(LUA_CFLAGS.*=\).*'\1 $(lua_get_CFLAGS)'" \
		-e "s'\(LUA_LIBS.*=\).*'\1 $(lua_get_LIBS)'" \
		config.mak || die
	sed -i \
		-e 's!-std=c++1.!!' \
		-e 's/install -s/install/' \
		-e "s'\$(CXX)'\$(CXX) -I${S}/ipecanvas -I${S}/ipecairo -I${S}/include'" \
		common.mak || die
	default
}

src_compile() {
	emake \
		CXX=$(tc-getCXX) \
		IPEPREFIX="${EPREFIX}/usr" \
		IPEDOCDIR="${EPREFIX}/usr/share/doc/${PF}/html"
}

src_install() {
	emake install \
		IPEPREFIX="${EPREFIX}/usr" \
		IPEDOCDIR="${EPREFIX}/usr/share/doc/${PF}/html" \
		INSTALL_ROOT="${ED}"
	dodoc ../{news,readme}.txt
	make_desktop_entry ipe Ipe ipe
}
