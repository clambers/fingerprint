%define id_hash BMQA0bTQCY
%define extdir %{_libdir}/tizen-extensions-crosswalk/
%define pcdir %{_datadir}/pkgconfig/
%define wgtdir %{_datadir}/wgt/
%define ruledir %{_libdir}/udev/rules.d/
%define debug_package %{nil}

Name:           fingerprint
Summary:        JLR Fingerprint web application
Version:        0.1
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

%description
This is a Crosswalk web application for fingerprint analysis, and an extension
for said app providing access to the libfprint library.

%prep
%autosetup

%build
./autogen.sh %{name} %{version} %{id_hash}
%configure
make %{?_smp_mflags}

%install
%make_install

%check
make %{?_smp_mflags} check

%post
/sbin/ldconfig
pkgcmd -i -t wgt -p %{wgtdir}Fingerprint.wgt -q > /dev/null

%preun
pkgcmd -u -n %{id_hash} -q > /dev/null

%postun -p /sbin/ldconfig

%files
%license LICENSE
%doc README.md NEWS.md
%{extdir}libfingerprint.so*
%{pcdir}fingerprint.pc
%{wgtdir}Fingerprint.wgt
%{ruledir}40-libfprint0.rules
