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

  class { '::mcollective':
    client             => true,
    middleware         => true,
    middleware_hosts   => [ 'puppet.nelson.va' ],
    middleware_ssl     => true,
    securityprovider   => 'ssl',
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs',
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/puppet.nelson.va.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/puppet.nelson.va.pem',
  }

  user { 'root':
    ensure => present,
  } ->
  mcollective::user { 'root':
    homedir     => '/root',
    certificate => 'puppet:///modules/site_mcollective/client_certs/root.pem',
    private_key => 'puppet:///modules/site_mcollective/private_keys/root.pem',
  }

  mcollective::plugin { 'puppet':
    package => true,
  }
}
