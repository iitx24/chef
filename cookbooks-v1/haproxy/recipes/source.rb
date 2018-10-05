%w{perl make gcc gcc-c++ patch which}.each do |pkg|
package pkg
end


user "haproxy" do
gid "asgapp"
home "/home/haproxy"
shell "/bin/bash"
end


script "haproxy_cleanup" do
interpreter "bash"
user "root"

code <<-JUNK
if [ -d #{node[:haproxy][:src_dir]} ]; then
  rm -rf '#{node[:haproxy][:src_dir]}'
else
  echo "#{node[:haproxy][:src_dir]} not found"
fi
if [ -d /usr/sbin/haproxy]; then
   rm -rf /usr/sbin/haproxy
  else
     echo "not found"
fi
JUNK
end


directory "#{node[:haproxy][:src_dir]}" do
    owner "cspd-admin"
    group "asgapp"
    recursive true
    action :create
    not_if "test -d #{node[:haproxy][:src_dir]}"
end

 %w{ haproxy-1.4.23.tar.gz }.each do |f|
    cookbook_file "#{node[:haproxy][:src_dir]}/#{f}" do
      owner "cspd-admin"
      group "asgapp"
      source f
      not_if "test -f #{node[:haproxy][:src_dir]}/#{f}"
    end
 end

  execute "extract haproxy source" do
    user "cspd-admin"
    group "asgapp"
    cwd "#{node[:haproxy][:src_dir]}"
    command "tar xzvf haproxy-1.4.23.tar.gz"
  end

#  execute "compile haproxy" do
#    user "root"
#    #cwd "#{node[:haproxy][:src_dir]}/haproxy-1.4.23"
#    cwd "/opt/haproxy/haproxy-1.4.23"
#    command "/usr/bin/make TARGET=linux26"
#    command "cp haproxy /usr/sbin/haproxy"
#  end
  
script "compile haproxy" do
interpreter "bash"
user "root"
code <<-JUNK
cd /opt/haproxy/haproxy-1.4.23
make TARGET=linux26
cp haproxy /usr/sbin/haproxy
JUNK
end

    cookbook_file "/etc/init.d/haproxy" do
    source "haproxy.init.d"
    owner "root"
    group "root"
    mode "0755"
  end

  include_recipe "haproxy::config"
