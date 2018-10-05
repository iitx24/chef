
script "Create SSL Certificates" do
	# Steps
	# =====
	#	1) Create an SSL private key.
	#	2) Create certificate signing request (CSR).
	#
	# @param node[:fqdn]: The hostname or fqdn of the server.
	# @param node[:stunnel][:server_ssl_req]

  interpreter "bash"
	cwd "/usr/local/etc/stunnel"
    creates "/usr/local/etc/stunnel/stunnel.pem"
	code <<-EOH
	umask 077
	openssl genrsa 2048 > private/#{node[:fqdn]}.key
	openssl req -subj "#{node[:stunnel][:server_ssl_req]}" -new -x509 -nodes -sha1 -days 3650 -key private/#{node[:fqdn]}.key > certs/#{node[:fqdn]}.crt
	cat private/#{node[:fqdn]}.key certs/#{node[:fqdn]}.crt > certs/stunnel.pem
	EOH
end
