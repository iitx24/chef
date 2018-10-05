
 script "setup_stunnel" do
  interpreter "bash"
  user "root"
  code <<-EOH
  groupadd asgapp 
  useradd -g asgapp -u 70003 -c "///// stunnel application user" stunnel 
  cd /etc
  ln -s /usr/local/etc/stunnel stunnel 
  cd /usr/sbin
  ln -s /usr/local/bin/stunnel stunnel
  chown -R stunnel:asgapp /usr/sbin/stunnel
  chown -R stunnel:asgapp /usr/local/etc/stunnel
  mkdir -p /var/log/stunnel/
  chown -R stunnel:asgapp /var/log/stunnel/
  mkdir -p /var/run/stunnel/
  chown -R stunnel:asgapp /var/run/stunnel/
  EOH
  end 
