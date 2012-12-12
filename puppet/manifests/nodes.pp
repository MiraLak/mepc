node /(int)?front[0-9]{14}/ {
	include base
	class {'nginx':}
	nginx::resource::vhost { 'localhost':
        	ensure   => present,
        	www_root => '/var/www',
		require => File['/var/www'],
		notify => Exec['reload nginx'],
	}
	file {'/var/www':
		ensure  => present,
		owner   => 'www-data',
		mode    => 755,
	}
	exec {'reload nginx':
		command => '/usr/sbin/service nginx reload',
		unless => 'sudo netstat -tunelp |grep nginx',
		require => Exec[rebuild-nginx-vhosts],
	}
}

node /(int)?app[0-9]{14}/ {
	include base
}

node /(int)?legacy-db[0-9]{14}/ {
	include base
	include mysql::server
}

node /(int)?db[0-9]{14}/ {
	include base
	class {'mongodb':
		enable_10gen => true,
	}
}

node cache {
}

node monitor {
	include base
}

node puppet {
	include base
	include puppet_mepc
}
