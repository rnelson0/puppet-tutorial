#puppet-augeas [![Build Status](https://travis-ci.org/Spredzy/puppet-augeas.png)](https://travis-ci.org/Spredzy/puppet-augeas)

=============

A Puppet module that installs augeas latest GitHub version, from the YUM repository (yum.augeas.yanisguenane.fr)[http://yum.augeas.yanisguenane.fr]

# Parameters

* devel (true|false)

Indicate if augeas-devel package should be installed (default: false)


# Usage

    Class['augeas']

or

    class {'augeas' :
      devel => true,
    }

# Compatibility

This module work exclusively on Fedora and RedHat (and its derivative) platforms, for both 32 Bits and 64 Bits platforms.
