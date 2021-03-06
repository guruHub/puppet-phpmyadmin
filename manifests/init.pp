class phpmyadmin(
  $dbuser = "puppet",
  $dbpass = "puppet_user",
  $dbname = "puppet",
  $installpath = "/usr/share/phpmyadmin/"
){

  $pma_version = '3.5.3'

  # Download latest pma
  exec { 'download latests pma':
    command => "/usr/bin/wget -o /dev/null -O /tmp/phpmyadmin.latest.tar.gz http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/${pma_version}/phpMyAdmin-${pma_version}-english.tar.gz/download",
    creates => "/tmp/phpmyadmin.latest.tar.gz"
  } -> exec { 'untar phpmyadmin':
    command => '/bin/tar -xzvf /tmp/phpmyadmin.latest.tar.gz',
    creates => "/tmp/phpMyAdmin-${pma_version}-english",
    cwd     => "/tmp",
    group   => root,
    user    => root,
    require => Exec['download latests pma']
  } -> file {$installpath:
    ensure => directory,
    recurse => true,
    group => 'www-data',
    owner => "www-data",
    mode => 644,
  } -> exec { 'Move to the install path':
    command => "/bin/mv /tmp/phpMyAdmin-${pma_version}-english ${installpath}",
    group   => root,
    user    => root,
    creates => "${installpath}/phpMyAdmin-${pma_version}-english"
  
  } -> file { "${installpath}/latest":
    ensure  => lynk,
    target  => "${installpath}/phpMyAdmin-${pma_version}-english",
  }

}
