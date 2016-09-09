# Copyright 2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# WANT_AUTOMAKE="1.11" # bug 419455

inherit autotools flag-o-matic libtool toolchain-funcs multilib-minimal

MY_P=${P%_*}
MY_PV=${PV%_*}
DEB_PATCH=${PV#*p}

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="http://recode.progiciels-bpi.ca/"
SRC_URI="
	mirror://gnu/${PN}/${MY_P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${MY_PV}-${DEB_PATCH}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls static-libs"

DEPEND="
	sys-devel/flex
	nls? ( sys-devel/gettext )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	# fix #571106 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	rm "${WORKDIR}"/debian/patches/series || die
	eapply "${FILESDIR}/${MY_P}-gettextfix.diff"
	eapply "${FILESDIR}"/${MY_P}-as-if.patch
	eapply "${WORKDIR}"/debian/patches/*
	sed -i '1i#include <stdlib.h>' src/argmatch.c || die

	# Avoid WANT_AUTOMAKE="1.11" (bug 419455):
	sed -i -e '/^AM_C_PROTOTYPES/d'  configure.in || die
	sed -i -e 's/ansi2knr//' src/Makefile.am || die

	# Remove old libtool macros
	rm "${S}"/acinclude.m4 || die

	mv configure.in configure.ac || die

	eapply_user
	eautoreconf
	elibtoolize
}

multilib_src_configure() {
	# on solaris -lintl is needed to compile
	[[ ${CHOST} == *-solaris* ]] && append-libs "-lintl"
	# --without-included-gettext means we always use system headers
	# and library
	ECONF_SOURCE="${S}" econf \
		--without-included-gettext \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -exec rm -f {} + || die
	rm -f "${ED}"/usr/lib/charset.alias || die
}