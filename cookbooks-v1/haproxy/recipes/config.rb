pool_members = search("node", "(role:#{node[:haproxy][:app_server_role1]} OR role:#{node[:haproxy][:app_server_role2]}) AND chef_environment:#{node.chef_environment}") || []
puts pool_members.to_s

pool_members.each do|member|
puts member.name
puts member[:ipaddress]
end
directory "/etc/haproxy" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
   :pool_members => pool_members.uniq
  })
  #notifies :restart, "service[haproxy]"
end

#service "haproxy" do
#  supports :restart => true, :status => true, :reload => true
#  action [:enable, :start]
#end

script "stop haproxy" do
interpreter "bash"
  code <<-EOH
       PID=`ps aux | grep haproxy | grep -v grep | awk {'print $2'}`
       echo $PID
       if [ -n "$PID" ]
       then
         kill -9 `ps aux | grep haproxy | grep -v grep | awk {'print $2'}`
         echo "Haproxy kill status is $?"
       else
         echo "No haproxy process to stop"
       fi
  EOH
end

service "haproxy" do
  action [:enable, :start]
end
