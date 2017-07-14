# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mv_mozextension-r1
RESTRICT="mirror"

DESCRIPTION="Firefox plugin for ebook (.epub) files"
HOMEPAGE="http://addons.mozilla.org/de/firefox/addon/epubreader/"
SRC_URI="https://addons.cdn.mozilla.net/user-media/addons/45281/${P}-an+fx.xpi"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

moz_defaults -i'{5384767E-00D9-40E9-B72F-9CC39D655D6F}' firefox

DEPEND="${DEPEND}
	!${CATEGORY}/${PN}:1[browser_firefox]
	!${CATEGORY}/${PN}:1[browser_firefox-bin]
"