# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} pypy )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 udev

DESCRIPTION="Validity fingerprint sensor prototype"
HOMEPAGE="https://github.com/uunicorn/python-validity"
SRC_URI="https://github.com/uunicorn/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/innoextract
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-auth/open-fprintd
	sys-auth/fprintd-clients
"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/logging_to_file.patch"
)

python_install_all() {
	distutils-r1_python_install_all

	udev_newrules "${S}"/debian/python3-validity.udev 60-python-validity.rules

	insinto /etc/python-validity
	doins "${S}"/etc/python-validity/dbus-service.yaml

	doinitd "${FILESDIR}"/validity-dbus
}

pkg_postinst() {
        elog "This set of ebuilds are for use with OpenRC."
	elog "Add the service to startup by:"
	elog "rc-update add validity-dbus"
	elog "                           "
	elog "To be able to use the fingerprint in different occasions,"
	elog "see: https://wiki.gentoo.org/wiki/Fingerprint_Reader"
}