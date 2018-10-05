
  cookbook_file "/usr/local/etc/stunnel/stunnel.conf" do
    source "#{node[:app]}/#{node[:app_environment]}/stunnel.conf"
    Chef::Log::debug("source file #{source}")
    owner "stunnel"
    group "asgapp"
    mode "0755"
  end
