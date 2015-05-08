ACLOCAL_AMFLAGS = -I m4
AM_MAKEFLAGS = --no-print-directory
EXTRA_DIST = \
	$(srcdir)/LICENSE \
	$(srcdir)/README.md \
	$(srcdir)/NEWS.md \
	$(srcdir)/autogen.sh \
	$(srcdir)/build-aux/js2c.sh \
	$(srcdir)/packaging/fingerprint.spec.in \
	$(srcdir)/packaging/fingerprint.spec \
	$(srcdir)/m4/package.m4
SUBDIRS = lib src tests

pcdir = $(datadir)/pkgconfig
pc_DATA = fingerprint.pc
