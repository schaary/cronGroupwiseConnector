# encoding: utf-8

require_relative "../test/test_helper"
require_relative "../lib/dispatcher"

class DispatcherTest < Minitest::Test
  def setup
    @account = MiniTest::Mock.new

    @account.expect :firstname, "Elvis Aaron"
    @account.expect :lastname, "Presley"
    @account.expect :uid, "elvis"
    @account.expect :uid_number, 13792
    @account.expect :gid_number, 1005
    @account.expect :password, "tESSt-42"
  end

  def test_dispatch_ldif_add_line

    ldif_add_line = \
      "dn: uid=elvis,ou=mail,o=mlu,c=de\n" +
      "sn: Presley\n" +
      "givenNane: Elvis Aaron"

    dispatcher = Dispatcher.new
    assert_equal dispatcher.dispatch_ldif_add_line, ldif_add_line
  end


end
