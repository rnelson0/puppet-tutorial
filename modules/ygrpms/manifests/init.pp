# == Class: ygrpms
#
#  A Puppet module that installs and configure ygrpms repo
#
# === Parameters
#
# [*enable*]
#   Should the repo be enabled (true|false)
#
# === Example
#
#  Class['ygrpms']
#
#  or
#
#  class {'ygrpms' :
#         enabled => false,
#  }
#
# === Authors
#
#  Yanis Guenane  <yguenane@gmail.com>
#
# === Copyright
#
# Copyright 2013 Yanis Guenane
#
class ygrpms (
  $enabled  = true,
  ) {

  require stdlib

  validate_bool($enabled)

  $rootrepo = $::operatingsystem ? {
    'Fedora'  => 'fedora',
    default   => 'el',
  }

  $ver = $::operatingsystem ? {
    'Fedora' => "f${::operatingsystemmajrelease}",
    default  => $::operatingsystemmajrelease,
  }

  $arch = $::architecture

  $in_enabled = $enabled ? {
    true  => 1,
    false => 0,
  }

  if $::osfamily == 'RedHat' {

    yumrepo {'ygrpms':
      baseurl         => "http://yum.yanisguenane.fr/${rootrepo}/${ver}/${arch}/",
      failovermethod  => 'priority',
      enabled         => $in_enabled,
      gpgcheck        => '0',
      descr           => 'Yanis Guenane\'s YUM repository for Fedora and EL linux based distributions',
    }

  }
  else {
    fail('Sorry, your Operating System is not supported, only RedHat based (and Fedora) linux distributions are supported')
  }

}
