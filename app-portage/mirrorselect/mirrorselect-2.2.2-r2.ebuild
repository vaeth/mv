# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )
PYTHON_REQ_USE="xml"

inherit distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Mirrorselect"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/mirrorselect/${P}.tar.gz
	https://dev.gentoo.org/~dolsen/releases/mirrorselect/mirrorselect-test
	"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-util/dialog
	net-analyzer/netselect
	>=dev-python/ssl-fetch-0.3[${PYTHON_USEDEP}]
	"

PATCHES=(
	"${FILESDIR}/mirrorselect-2.2.2-Update-for-ssl-fetch-api-change.patch"
	"${FILESDIR}/mirrorselect-2.2.2-Add-outputmodefunctionassignment.patch"
)

python_prepare_all()  {
	python_setup
	eprefixify setup.py mirrorselect/main.py
	echo Now setting version... VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"
	distutils-r1_python_prepare_all
}
