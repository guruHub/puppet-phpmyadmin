class phpmyadmin(
	$dbuser = "puppet",
	$dbpass = "puppet_user",
	$dbname = "puppet",
	$installpath = "/usr/share/"
){

  $pma_version = '3.5.3'

  # Download latest pma
  exec { 'download latests pma':
    command => "/usr/bin/wget -o /dev/null -O /tmp/phpmyadmin.latest.gz http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/${pma_version}/phpMyAdmin-${pma_version}-english.tar.gz/download"
  }

  exec { 'untar phpmyadmin':
		command => '/bin/tar -xzvf /tmp/phpmyadmin.latest.tar.gz',
		creates => "/tmp/phpMyAdmin-${pma_version}-english",
		cwd     => "/tmp",
		group   => root,
		user    => root,
		require => Exec['download latests pma']
  }

	exec { 'Move to the install path':
		command => "/bin/mv /tmp/phpMyAdmin-${pma_version}-english ${installpath}",
		group => root,
		user => root,
		onlyif => "/usr/bin/test ! -d ${installpath}",
		require => [ Exec['untar phpmyadmin'], File[$installpath] ]
  }

	file {$installpath:
    ensure => directory,
    recurse => true,
    group => 'www-data',
    owner => "www-data",
    mode => 644,
	}

  file { "${installpath}/phpmyadmin":
    ensure  => lynk,
    target  => "${installpath}/phpMyAdmin-${pma_version}-english",
    require => Exec['Move to the install path']
  }

}
