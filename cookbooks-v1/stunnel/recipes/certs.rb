
  cookbook_file "/usr/local/etc/stunnel/speech.#{node[:app_environment]}.enabler.attcompute.com.key" do
    source "#{node[:app]}/#{node[:app_environment]}/speech.#{node[:app_environment]}.enabler.attcompute.com.key"
    owner "stunnel"
    group "asgapp"
    mode "0400"
  end
# we need handle it differently   
  cookbook_file "/usr/local/etc/stunnel/cacert_blackflag.pem" do
    source "#{node[:app]}/#{node[:app_environment]}/cacert_blackflag.pem"
    owner "stunnel"
    group "asgapp"
    mode "0400"
  end
  
  cookbook_file "/usr/local/etc/stunnel/cert.cer" do
    source "#{node[:app]}/#{node[:app_environment]}/cert.cer"
    owner "stunnel"
    group "asgapp"
    mode "0400"
  end
