%global __debug_install_post %{nil}
%global debug_package %{nil}

%define name fingerprint
%define capname Fingerprint
%define version 0.0.1
%define hash BMQA0bTQCY

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
su app -c "pkgcmd -i -t wgt -p %{wgtfile} -q"

%preun
su app -c "pkgcmd -u -n %hash -q"

%postun -p /sbin/ldconfig

%files
%license LICENSE
%doc README.md NEWS.md
%{extdir}lib%{name}.so*
%{pcdir}%{name}.pc
%{wgtfile}
%{ruledir}40-libfprint0.rules
