Name:           puppet-ygrpms
Version:        0.1.0
Release:        1%{?dist}
Summary:        A Puppet module that installs and configure ygrpms repo

Group:          System Environment/Libraries
License:        Apache v2
URL:            http://forge.puppetlabs.com/yguenane/augeas
Source0:        http://forge.puppetlabs.com/yguenane/augeas/%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       puppet puppet-stdlib

%description
A Puppet module that installs and configure ygrpms repo

%prep
%setup -n yguenane-ygrpms-%{version}

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/etc/puppet/modules/ygrpms/
cp -r manifests $RPM_BUILD_ROOT/etc/puppet/modules/ygrpms/

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{_sysconfdir}/puppet/modules/*
%doc CHANGELOG README.md LICENSE

%changelog
* Fri Oct 10 2013  Yanis Guenane  <yguenane@gmail.com>  0.1.0
- Initial version

