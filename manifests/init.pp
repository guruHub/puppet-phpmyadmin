class phpmyadmin{

	package { "phpmyadmin":
		ensure => installed,
		require => [Service["apache2"], Package["php5"]]
	}

	exec{ "link phpmyadmin config":
		command => "ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf",
		unless => "/bin/readlink -e /etc/apache2/conf.d/phpmyadmin.conf",
		require => Package["phpmyadmin"],
		notify => Service["apache2"],
	}

	file{"phpmyadmin config":
		path => "/usr/share/php/config.inc.php",
		content => template("phpmyadmin/config.inc.php.erb"),
		require => Package["phpmyadmin"]
	}

}
