Name:           puppet-augeas
Version:        0.1.1
Release:        1%{?dist}
Summary:        A puppet module that installs a nightly build of augeas

Group:          System Environment/Libraries
License:        Apache v2
URL:            http://forge.puppetlabs.com/yguenane/augeas
Source0:        http://forge.puppetlabs.com/yguenane/augeas/%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       puppet puppet-stdlib puppet-ygrpms

%description
A puppet module that installs a nightly build of the Augeas project based
on the GitHub sources.

%prep
%setup -n yguenane-augeas-%{version}

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/etc/puppet/modules/augeas/
cp -r manifests $RPM_BUILD_ROOT/etc/puppet/modules/augeas/

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{_sysconfdir}/puppet/modules/*
%doc CHANGELOG README.md LICENSE

%changelog
* Fri Oct 10 2013  Yanis Guenane  <yguenane@gmail.com>  0.1.1
- Remove yum repo instanciation from this module to its own module
- Add dependence to yguenane/ygrpms and puppetlabs/stdlib

* Fri Oct 4 2013  Yanis Guenane  <yguenane@gmail.com>  0.1.0
- Initial version

