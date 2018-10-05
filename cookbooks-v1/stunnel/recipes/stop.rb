
 script "stop_stunnel" do
  interpreter "bash"
  user "root"
  code <<-EOH
  "/etc/init.d/stunnel stop" 
  EOH
 end
