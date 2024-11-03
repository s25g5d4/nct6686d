%global pkgver MAKEFILE_PKGVER
%global commithash MAKEFILE_COMMITHASH

Name:           nct6686d
Version:        1.0.%{pkgver}
Release:        git%{commithash}
Summary:        Kernel module (kmod) for %{prjname}
License:        GPL-2.0
URL:            https://github.com/s25g5d4/nct6686d
Source0:        nct6686.conf

# For kmod package
Provides:       %{name}-kmod-common = %{version}-%{release}
Requires:       %{name}-kmod >= %{version}

BuildArch:      noarch

%description
%{prjname} kernel module

%prep

%build
# Nothing to build

%install

install -D -m 0644 %{SOURCE0} %{buildroot}%{_modulesloaddir}/nct6686.conf

%files
%{_modulesloaddir}/nct6686.conf

%changelog
* Sun Nove 03 2024 Zong Jhe Wu <s25g5d4@gmail.com> - %{version}
- Initial package
