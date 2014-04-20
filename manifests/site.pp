node 'puppet.nelson.va' {
  include ::base
  notify { "Generated from our notify branch": }

  # PuppetDB
  include ::puppetdb
  include ::puppetdb::master::config

  # Hiera
  package { ['hiera', 'hiera-puppet']:
    ensure => present,
  }
}
