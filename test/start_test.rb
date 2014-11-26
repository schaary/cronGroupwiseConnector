# encoding: utf-8

require_relative "../test/test_helper"
require_relative "../lib/dispatcher"
require_relative "../lib/account"

require 'base64'
require 'digest/sha1'

class DispatcherTest < Minitest::Test
  def setup
    @account = Account.new

    @account.firstname = "Elvis Aaron"
    @account.lastname = "Presley"
    @account.uid = "elvis"
    @account.uid_number = 13792
    @account.gid_number = 1005
    @account.mail = 'elvis@example.com'
    @account.password = "tESSt-42"
  end

  def test_dispatch_ldif_add_line

    ldif_add_line = \
      "dn: uid=#{@account.uid},ou=mail,o=mlu,c=de\n" +
      "sn: #{@account.lastname}\n" +
      "givenName: #{@account.firstname}\n" +
      "cn: #{@account.firstname} #{@account.lastname}\n" +
      "mail: #{@account.mail}\n" +
      "userPassword: {SHA1}#{Base64.encode64(Digest::SHA1.hexdigest(@account.password)).strip}\n" +
      "objectclass: top\n" +
      "objectclass: person\n" +
      "objectclass: inetOrgPerson\n\n"

    dispatcher = Dispatcher.new
    assert_equal dispatcher.dispatch_ldif_add_line(account: @account), ldif_add_line
  end


end
