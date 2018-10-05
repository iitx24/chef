#
# Cookbook Name:: stunnel
# Recipe:: source 
#
#pkgs = value_for_platform(
#    ["redhat","centos","fedora","scientific"] =>
#        {"default" => %w{ patch }},
#    [ "debian", "ubuntu" ] =>
#        {"default" => %w{ patch}},
#    "default" => %w{ patch}
#  )

#pkgs.each do |pkg|
#  package pkg do
#    action :install
#  end
#end

  script "stunnel_cleanup" do
  interpreter "bash"
  code <<-EOH
  if [ -d #{node[:stunnel][:src_dir]} ]; then
    rm -rf #{node[:stunnel][:src_dir]}
  else
    echo "#{node[:stunnel][:src_dir]} not found"
  fi

 if [ -d /usr/local/etc/stunnel ]; then
    rm -rf /usr/local/etc/stunnel
  else
     echo "not found"
  fi

  if [ -f /usr/local/bin/stunnel ]; then
     rm -rf /usr/local/bin/stunnel
  else
      echo "not found"
  fi
  
  if [ -f /usr/sbin/stunnel ]; then
     rm -rf /usr/sbin/stunnel
  else
      echo "not found"
  fi
  if [ -d /etc/stunnel ]; then
    rm -rf /etc/stunnel
  else
     echo "not found"
  fi
  EOH
  end

 directory "#{node[:stunnel][:src_dir]}" do
    owner "cspd-admin"
    group "asgapp"
    recursive true
    action :create
    not_if "test -d #{node[:stunnel][:src_dir]}"
 end
  

  # TODO roll out 4.56 on non-solaris platforms too
  %w{ stunnel-4.56.tar.gz stunnel-4.53-xforwarded-for.diff }.each do |f|
    cookbook_file "#{node[:stunnel][:src_dir]}/#{f}" do
      source f
      not_if "test -f #{node[:stunnel][:src_dir]}/#{f}"
    end
  end

  execute "extract stunnel source" do
    cwd "#{node[:stunnel][:src_dir]}"
    command "tar xzvf stunnel-4.56.tar.gz"
  end

 # execute "stunnel xforwarded-for patch" do
 #   cwd "#{node[:stunnel][:src_dir]}/stunnel-4.53"
 #   command "patch -p1 < ../stunnel-4.53-xforwarded-for.diff"
 # end
  
  execute "compile stunnel" do
    cwd "#{node[:stunnel][:src_dir]}/stunnel-4.56"
    #command "./configure --prefix=/opt/local --disable-libwrap --disable-fips && make && make install"
    command "./configure --disable-fips && make && make install"
  end

  cookbook_file "/etc/init.d/stunnel" do
    source "stunnel.init.d"
    owner "root"
    group "root"
    mode "0755"
  end
 
  include_recipe "stunnel::setup" 
  include_recipe "stunnel::config" 
  include_recipe "stunnel::certs" 
  include_recipe "stunnel::service"
