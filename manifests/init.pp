class phpmyadmin(
	$dbuser = "puppet",
	$dbpass = "puppet_user",
	$dbname = "puppet",
	$installpath => "/usr/share/phpmyadmin"
){


	file { '/tmp/phpMyAdmin-3.5.3.tar.gz':
		ensure => file,
		owner => root,
		group => root,
		source => 'puppet:///phpmyadmin/phpMyAdmin-3.5.3.tar.gz',
    }

    exec { 'untar phpmyadmin':
		command => '/bin/tar -xvzf /tmp/phpMyAdmin-3.5.3.tar.gz',
		creates => '/tmp/phpMyAdmin-3.5.3-all-languages',
		cwd => "/tmp",
		group => root,
		user => root,

		require => File['/tmp/phpMyAdmin-3.5.3.tar.gz'],
    }

	exec { '/bin/mv /tmp/phpMyAdmin-3.5.3-all-languages ${installpath}':
		group => root,
		user => root,
		require => Exec['untar phpmyadmin'],
    }

	file {'${installpath}':
			ensure => directory,
			group => 'www-data',
			recurse => true,
			owner => "www-data",
			require => Exec['untar phpmyadmin'],
    }

	file{ "create phpmyadmin apache config":
		content => template("phpmyadmin/phpmyadmin.conf.erb"),
		path => "/etc/apache2/conf.d/phpmyadmin.conf"
		require => File["${installpath}"],
		notify => Service["apache2"],
	}

	file{"phpmyadmin config":
		path => "/usr/share/phpmyadmin/config.inc.php",
		content => template("phpmyadmin/config.inc.php.erb"),
		require => Package["phpmyadmin"],
		owner => "www-data",
		group => "www-data",
		mode => 644
	}

}
