# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mv_mozextension-r1
RESTRICT="mirror"

mPN="${PN//-/_}-${PV}"
DESCRIPTION="<firefox-57 add-on: restore partially the look of classical firefox"
HOMEPAGE="https://addons.mozilla.org/de/firefox/addon/classicthemerestorer/"
SRC_URI="https://addons.cdn.mozilla.net/user-media/addons/472577/${mPN}-fx.xpi"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

moz_defaults '<firefox-57'