
 script "restart_stunnel" do
  interpreter "bash"
  user "root"
  code <<-EOH
  /etc/init.d/stunnel stop
  /etc/init.d/stunnel start
  EOH
 end
