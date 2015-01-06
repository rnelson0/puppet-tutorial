class { 'r10k':
  version => '1.4.0',
  sources => {
    'puppet' => {
      'remote'  => 'git@github.com:rnelson0/puppet-tutorial.git',
      'basedir' => "${::settings::confdir}/environments",
      'prefix'  => false,
    },
    'hiera' => {
      'remote'  => 'git@github.com:rnelson0/hiera_home.git',
      'basedir' => "/etc/puppet/hiera",
      'prefix'  => false,
    }
  },
  manage_modulepath => false
}
