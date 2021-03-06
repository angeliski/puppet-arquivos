include mysql::client

$keystore_file = "/etc/ssl/.keystore"
$ssl_connector = {
	"port" => 8443,
	"protocol" => "HTTP/1.1",
	"SSLEnabled" => true,
	"maxThreads" => 150,
	"scheme" => "https",
	"secure" => "true",
	"keystoreFile" => $keystore_file,
	"keystorePass" => "kurosaki",
	"clientAuth" => false,
	"sslProtocol" => "SSLv3",
}

$db = {
	"user" => "loja",
	"password" => "lojasecret",
	"driver" => "com.mysql.jdbc.Driver",
	"url" => "jdbc:mysql://192.168.33.10:3306/loja_schema",
}

file { $keystore_file:
	mode => 0644,
	source => "/vagrant/manifests/.keystore",
}
class { "tomcat::server":
	connectors => [$ssl_connector],
	data_sources => {
		"jdbc/web" => $db,
		"jdbc/secure" => $db,
		"jdbc/storage" => $db,
	},
	require => File[$keystore_file],
}