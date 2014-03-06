define base::user ( $state, $id, $uid, $pass, $realname, $sgroups) {
  user { $id:
    ensure => $state,
    uid => $uid,
    shell => "/bin/bash",
    home => "/home/$id",
    comment => $realname,
    managehome => true,
    groups => $sgroups,
    password_max_age => '90',
  }
 
  case $::osfamily {
    RedHat: {$action = "/bin/sed -i -e 's/$id:!!:/$id:$pass:/g' /etc/shadow; chage -d 0 $id"}
    Debian: {$action = "/bin/sed -i -e 's/$id:x:/$id:$pass:/g' /etc/shadow; chage -d 0 $id"}
  }
 
  exec { "$action":
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "egrep -q  -e '$id:!!:' -e '$id:x:' /etc/shadow",
    require => User[$id]
  }
}
