service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
