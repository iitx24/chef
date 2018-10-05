class TestStunnel < MiniTest::Chef::TestCase
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  def test_stunnel_running
    service("stunnel").must_be_running
  end

  def test_logrotate
    logrotate = "/etc/logrotate.d/stunnel"
    assert ::File.exists?(logrotate)
    assert File.read(logrotate) =~ /postrotate/
  end
end
