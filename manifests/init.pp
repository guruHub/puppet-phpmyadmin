class phpmyadmin(
	$dbuser = "puppet",
	$dbpass = "puppet_user",
	$dbname = "puppet",
	$installpath = "/usr/share/phpmyadmin"
){


	file { '/tmp/phpMyAdmin-3.5.3.tar.gz':
		ensure => file,
		owner => root,
		group => root,
		source => 'puppet:///modules/phpmyadmin/phpMyAdmin-3.5.3.tar.gz',
    }

    exec { 'untar phpmyadmin':
		command => '/bin/tar -xzvf /tmp/phpMyAdmin-3.5.3.tar.gz',
		creates => '/tmp/phpMyAdmin-3.5.3-all-languages',
		cwd => "/tmp",
		group => root,
		user => root,

		require => File['/tmp/phpMyAdmin-3.5.3.tar.gz'],
    }

	exec { 'Move to the install path':
		command => "/bin/mv /tmp/phpMyAdmin-3.5.3-all-languages ${installpath}",
		group => root,
		user => root,
		onlyif => "test ! -d ${installpath}",
		require => Exec['untar phpmyadmin'],
    }

	file {$installpath:
			ensure => directory,
			recurse => true,
			group => 'www-data',
			owner => "www-data",
			mode => 644,
			require => Exec['Move to the install path'],
	}

	file{ "create phpmyadmin apache config":
		content => template("phpmyadmin/phpmyadmin.conf.erb"),
		path => "/etc/apache2/conf.d/phpmyadmin.conf",
		require => File[$installpath],
		notify => Service["apache2"],
	}

	file{"phpmyadmin config":
		path => "${installpath}/config.inc.php",
		content => template("phpmyadmin/config.inc.php.erb"),
		require => Exec["Move to the install path"],
		owner => "www-data",
		group => "www-data",
		mode => 644
	}

}
