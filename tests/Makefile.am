TESTSUITE = $(top_srcdir)/tests/testsuite
TESTSUITE_AT = testsuite.at library.at

MODULES = node_modules

AUTOM4TE = $(top_srcdir)/build-aux/missing --run autom4te
AT = $(AUTOM4TE) --language=autotest
ATFLAGS = -I$(srcdir)

EXTRA_DIST = $(TESTSUITE) $(TESTSUITE_AT) atlocal.in node_modules.tar.xz

DISTCLEANFILES = atconfig atlocal
MAINTAINERCLEANFILES = $(TESTSUITE) package.m4

$(TESTSUITE): $(TESTSUITE_AT)
	$(AM_V_GEN) $(AT) $(ATFLAGS) -o $@.tmp $@.at
	$(AM_V_at)mv $@.tmp $@

$(MODULES): node_modules.tar.xz
	$(AM_V_GEN) $(TAR) -xJf $<

check-local: all atconfig atlocal $(TESTSUITE) $(MODULES)
	$(AM_V_at)$(SHELL) $(TESTSUITE)

installcheck-local: all atconfig atlocal $(TESTSUITE) $(MODULES)
	$(AM_V_at)$(SHELL) $(TESTSUITE) AUTOTEST_PATH='$(bindir)'

clean-local:
	test ! -f $(TESTSUITE) || $(SHELL) $(TESTSUITE) --clean

distclean-local:
	test ! -d $(MODULES) || rm -rf $(MODULES)
