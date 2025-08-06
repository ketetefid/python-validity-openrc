# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 udev

DESCRIPTION="D-Bus clients to access fingerprint readers"
HOMEPAGE="https://github.com/uunicorn/open-fprintd"
SRC_URI="https://github.com/uunicorn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"

RDEPEND="
	sys-auth/fprintd-clients
"
DEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all
}
