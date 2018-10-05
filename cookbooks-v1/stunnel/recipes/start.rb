
 script "start_stunnel" do
  interpreter "bash"
  user "root"
  code <<-EOH
  "/etc/init.d/stunnel start" 
  EOH
 end
