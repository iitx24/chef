case node['platform']
  when "ubuntu", "debian"
    node.default[:stunnel][:sysvinit_script] = "/etc/init.d/stunnel4"
    node.default[:stunnel][:pidfile_dir]     = "/var/run/stunnel4"
    node.default[:stunnel][:logfile_dir]     = "/var/log/stunnel4"
  else
    node.default[:stunnel][:sysvinit_script] = "/etc/init.d/stunnel"
    node.default[:stunnel][:pidfile_dir]     = "/var/run/stunnel"
    node.default[:stunnel][:logfile_dir]     = "/var/log/"
end


default[:stunnel][:version] = "4.53"
#default[:stunnel][:rpm_url] = "https://hub.sl.lumoslabs.com/chef/stunnel-#{node[:stunnel][:version]}-xforwarded-for.el#{node[:platform_version].to_i}.#{node[:kernel][:machine]}.rpm"
default[:stunnel][:debug] = 3
default[:stunnel][:server_ssl_req]  = "/C=US/ST=GA/L=Atlanta/O=ATT/OU=cspd/" +
	"CN=#{node.fqdn}/emailAddress=root@#{node.fqdn}"
default[:stunnel][:src_dir]="/opt/stunnel"
