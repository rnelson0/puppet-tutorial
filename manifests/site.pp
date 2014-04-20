node 'puppet.nelson.va' {
  include ::base
  notify { "Generated from our notify branch": }

  include ::puppetdb
  include ::puppetdb::master::config
}
