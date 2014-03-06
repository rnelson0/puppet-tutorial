# == Class: augeas
#
#  A puppet module that installs the latest version of Augeas
#
# === Parameters
#
# [*devel*]
#   Install the devel package
#
# === Example
#
#  Class['augeas']
#
# === Authors
#
#  Yanis Guenane  <yguenane@gmail.com>
#
# === Copyright
#
# Copyright 2013 Yanis Guenane
#
class augeas (
  $devel    = false,
  ) {

  require stdlib
  require ygrpms

  validate_bool($devel)

  $packages = $devel ? {
    true  =>  ['augeas', 'augeas-libs', 'augeas-devel'],
    false =>  ['augeas', 'augeas-libs'],
  }

  if $::osfamily == 'RedHat' {

    package {$packages:
      ensure  => installed,
    }

  }
  else {
    fail('Sorry, your Operating System is not supported, only RedHat based (and Fedora) linux distributions are supported')
  }

}
