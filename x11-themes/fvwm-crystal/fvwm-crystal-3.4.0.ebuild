# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT=mirror

PYTHON_COMPAT=( python2_7 )
inherit eutils readme.gentoo-r1 python-r1 user

DESCRIPTION="Configurable FVWM theme with transparency and freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+amixer jack +pm-utils +xdg"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

case ${PV} in
*9999)
	PROPERTIES="live"
	inherit subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/fvwm-crystal/code"
	SRC_URI=""
	KEYWORDS=""
	S="${WORKDIR}/${PN}"
	src_unpack() {
		subversion_src_unpack
	};;
esac

RDEPEND="${PYTHON_DEPS}
	>=x11-wm/fvwm-2.5.26[png]
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( x11-misc/hsetroot media-gfx/feh )
	sys-apps/sed
	sys-devel/bc
	virtual/awk
	x11-apps/xwd
	xdg? ( x11-misc/xdg-user-dirs )
	pm-utils? ( sys-power/pm-utils )
	amixer? ( media-sound/alsa-utils )
	jack? ( media-sound/jack-audio-connection-kit )"

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="After installation, execute the following commands:
\ \$ cp -r "${EROOT}"usr/share/doc/"${PF}"/addons/Xresources ~/.Xresources
\ \$ cp -r "${EROOT}"usr/share/doc/"${PF}"/addons/Xsession ~/.xinitrc

Many applications can extend functionality of fvwm-crystal.
They are listed in "${EROOT}"usr/share/doc/"${PF}"/INSTALL.*

To be able to use the exit menu, each user using ${PN}
must be in the group fvwm-crystal.
You can do that as root with:
	useradd -G fvwm-crystal <user_name>
and log out and in again.
"

pkg_setup() {
	enewgroup fvwm-crystal
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		docdir="${EPREFIX}/usr/share/doc/${PF}" \
		prefix="${EPREFIX}/usr" \
		install
	# GNU License is globally in the portage tree
	rm -vf "${ED}/usr/share/doc/${PF}"/LICENSE

	python_replicate_script \
		"${ED}/usr/bin/${PN}".{apps,wallpaper} \
		"${ED}/usr/share/${PN}"/fvwm/scripts/FvwmMPD/*.py
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
