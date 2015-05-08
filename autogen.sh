#!/bin/sh

NAME=fingerprint
VERSION=0.0.1
HASH=BMQA0bTQCY

AUTORECONF=`which autoreconf`
COMMONDIR=/opt/usr/apps/common-apps

if [ ! -d $COMMONDIR ]; then
  echo "*** No common dir found, please install common-apps ***"
  exit 1
fi

if [ -z $AUTORECONF ]; then
  echo "*** No autoreconf found, please install autoconf ***"
  exit 1
fi

mkdir -p m4 packaging

echo "generating package info..."
EOF=EOF_$RANDOM
echo "$(cat <<$EOF
# AX_IMPORT_PACKAGE_INFO
# ----------------------
# Import package information from an outside source.
AC_DEFUN([AX_IMPORT_PACKAGE_INFO],
[m4_define([AX_PACKAGE_NAME], [${NAME^}])
m4_define([AX_PACKAGE_VERSION], [$VERSION])
m4_define([AX_PACKAGE_HASH], [$HASH])
])
$EOF
)" > m4/package.m4

echo "generating specfile..."
EOF=EOF_$RANDOM
eval echo "\"$(cat <<$EOF
%global __debug_install_post %{nil}
%global debug_package %{nil}

%define name $NAME
%define capname ${NAME^}
%define version $VERSION
%define hash $HASH

%define extdir %{_libdir}/tizen-extensions-crosswalk/
%define pcdir %{_datadir}/pkgconfig/
%define wgtdir %{_datadir}/wgt/
%define ruledir %{_libdir}/udev/rules.d/

%define wgtfile %{wgtdir}%{capname}.wgt

Name:           %name
Summary:        JLR Fingerprint web application
Version:        %{version}
Release:        0
Group:          Applications/Web Applications
License:        MPL-2.0
URL:            http://www.tizen.org2
Source:         %{name}-%{version}.tar.bz2
BuildRequires:  pkgconfig(dlog)
BuildRequires:  pkgconfig(jansson)
BuildRequires:  pkgconfig(libfprint)
BuildRequires:  common-apps
BuildRequires:  zip
BuildRequires:  libxml2-tools
BuildRequires:  nodejs

%description
This is a Crosswalk web application for fingerprint analysis, and an extension
for said app providing access to the libfprint library.

%prep
%autosetup

%build
%configure
make %{?_smp_mflags} check

%install
%make_install

%post
/sbin/ldconfig
su app -c \"pkgcmd -i -t wgt -p %{wgtfile} -q\"

%preun
su app -c \"pkgcmd -u -n %hash -q\"

%postun -p /sbin/ldconfig

%files
%license LICENSE
%doc README.md NEWS.md
%{extdir}lib%{name}.so*
%{pcdir}%{name}.pc
%{wgtfile}
%{ruledir}40-libfprint0.rules
$EOF
)\"" > packaging/fingerprint.spec

echo "running autoreconf..."
$AUTORECONF -if

echo "importing common..."
cp -r $COMMONDIR src/DNA_common
