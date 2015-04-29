BUILT_SOURCES = fingerprint.h
JS2C = $(top_srcdir)/build-aux/js2c.sh
DISTCLEANFILES = fingerprint.h

extdir = $(libdir)/tizen-extensions-crosswalk

ext_LTLIBRARIES = libfingerprint.la
libfingerprint_la_SOURCES = fingerprint.c fingerprint.js XW_Extension.h
libfingerprint_la_CPPFLAGS = @dlog_CFLAGS@ @jansson_CFLAGS@ @libfprint_CFLAGS@
libfingerprint_la_LDFLAGS = -version 0:0:0
libfingerprint_la_LIBADD = @dlog_LIBS@ @jansson_LIBS@ @libfprint_LIBS@

%.h: %.js $(top_srcdir)/configure.ac
	$(AM_V_GEN) $(JS2C) @PACKAGE_TARNAME@ $< $@
