# Copyright 2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mv_mozextension-r1
RESTRICT="mirror"

mPN="${PN}_plus-${PV}"
DESCRIPTION="Firefox plugin: enable duckduckgo search engine"
HOMEPAGE="http://addons.mozilla.org/en-US/firefox/addon/duckduckgo-for-firefox/"
SRC_URI="https://addons.cdn.mozilla.net/user-media/addons/385621/${mPN}-fx.xpi"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

moz_defaults firefox

RDEPEND="${RDEPEND}
browser_firefox? ( !www-plugins/duckduckgo:0[browser_firefox] )
browser_firefox-bin? ( !www-plugins/duckduckgo:0[browser_firefox-bin] )"
