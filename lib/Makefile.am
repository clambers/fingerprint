BUILT_SOURCES = fingerprint.h
JS2C = $(top_srcdir)/build-aux/js2c.sh
EXTRA_DIST = 40-libfprint0.rules
DISTCLEANFILES = fingerprint.h

extdir = $(libdir)/tizen-extensions-crosswalk
ruledir = $(libdir)/udev/rules.d

ext_LTLIBRARIES = libfingerprint.la
libfingerprint_la_SOURCES = fingerprint.c fingerprint.js XW_Extension.h
libfingerprint_la_CPPFLAGS = @dlog_CFLAGS@ @jansson_CFLAGS@ @libfprint_CFLAGS@
libfingerprint_la_LDFLAGS = -version 0:0:0
libfingerprint_la_LIBADD = @dlog_LIBS@ @jansson_LIBS@ @libfprint_LIBS@

rule_DATA = 40-libfprint0.rules

%.h: %.js $(top_srcdir)/configure.ac
	$(AM_V_GEN) $(JS2C) @PACKAGE_TARNAME@ $< $@
