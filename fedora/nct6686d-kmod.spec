%if 0%{?fedora}
%global buildforkernels akmod
%global debug_package %{nil}
%endif

%global prjname nct6686d
%global pkgver MAKEFILE_PKGVER
%global commithash MAKEFILE_COMMITHASH
%define buildforkernels akmod

Name:           %{prjname}-kmod
Version:        1.0.%{pkgver}
Release:        git%{commithash}
Summary:        Kernel module (kmod) for %{prjname}
License:        GPL-2.0
URL:            https://github.com/s25g5d4/nct6686d
Source0:        nct6686d-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-root-%(%{__id_u} -n)


BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  elfutils-libelf-devel
BuildRequires:  kmodtool
Conflicts: 	    nct6686d-kmod-common

%{expand:%(kmodtool --target %{_target_cpu} --kmodname %{prjname} %{?buildforkernels:--%{buildforkernels}} %{?kernels:--for-kernels "%{?kernels}"} 2>/dev/null) }

%description
%{prjname} kernel module

%prep
kmodtool --target %{_target_cpu} --kmodname %{prjname} %{?buildforkernels:--%{buildforkernels}} %{?kernels:--for-kernels "%{?kernels}"} 2>/dev/null

%autosetup -n nct6686d-%{version}

for kernel_version in %{?kernel_versions} ; do
    cp -a nct6686d _kmod_build_${kernel_version%%___*}
done

%build
for kernel_version in %{?kernel_versions}; do
    make V=0 %{?_smp_mflags} -C "${kernel_version##*___}" M=${PWD}/_kmod_build_${kernel_version%%___*}
done

%install
for kernel_version in %{?kernel_versions}; do
 mkdir -p %{buildroot}%{kmodinstdir_prefix}/${kernel_version%%___*}/%{kmodinstdir_postfix}/
 install -D -m 755 _kmod_build_${kernel_version%%___*}/*.ko %{buildroot}%{kmodinstdir_prefix}/${kernel_version%%___*}/%{kmodinstdir_postfix}/
 chmod a+x %{buildroot}%{kmodinstdir_prefix}/${kernel_version%%___*}/%{kmodinstdir_postfix}/*.ko
done
%{?akmod_install}


%changelog
* Sun Nove 03 2024 Zong Jhe Wu <s25g5d4@gmail.com> - %{version}
- Initial package
