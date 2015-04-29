ACLOCAL_AMFLAGS = -I m4
AM_MAKEFLAGS = --no-print-directory
EXTRA_DIST = \
	$(srcdir)/LICENSE \
	$(srcdir)/README.md \
	$(srcdir)/NEWS.md \
	$(srcdir)/autogen.sh \
	$(srcdir)/configure.ac.in \
	$(srcdir)/build-aux/js2c.sh
SUBDIRS = lib src tests

pcdir = $(datadir)/pkgconfig
pc_DATA = fingerprint.pc
