AC_PREREQ([2.69])

AX_IMPORT_PACKAGE_INFO

AC_INIT(AX_PACKAGE_NAME, AX_PACKAGE_VERSION,
[https://github.com/PDXostc/fingerprint/issues], [],
[https://github.com/PDXostc/fingerprint])
AC_CONFIG_SRCDIR([lib/fingerprint.c])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([1.14 foreign -Wall -Werror -Wno-portability])
AM_SILENT_RULES([yes])

AC_SUBST([PACKAGE_HASH], AX_PACKAGE_HASH)

AM_PROG_AR
LT_INIT

AC_PROG_CC
AM_PROG_CC_C_O
PKG_CHECK_MODULES([dlog], [dlog])
PKG_CHECK_MODULES([jansson], [jansson])
PKG_CHECK_MODULES([libfprint], [libfprint])
AC_CHECK_PROGS([XML_LINT], [xmllint])
AC_CHECK_PROGS([ZIP], [zip])

AC_CONFIG_TESTDIR([tests])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile fingerprint.pc lib/Makefile src/Makefile
tests/Makefile src/fingerprint.xml tests/package.m4 tests/atlocal])

AC_OUTPUT
