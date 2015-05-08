# AX_PROG_TAR
# -----------
# Checks for existence of tar program.
AC_DEFUN([AX_PROG_TAR],
[AC_CHECK_PROGS([TAR], [tar])
AC_ARG_VAR([TAR], [The tar program to use.])
])
