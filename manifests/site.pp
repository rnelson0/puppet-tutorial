Package {
  allow_virtual => true,
}

node default {
  hiera_include('classes')
  hiera_include('ssh_authorized_keys')
}
