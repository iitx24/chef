
  service "stunnel" do
    supports :restart => true, :status => true, :stop => true, :start => true
    action [:enable,:restart]
  end
