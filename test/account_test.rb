# encoding: utf-8

require "test_helper"
require "account"

class AccountTest < Minitest::Test
  include FactoryGirl::Syntax::Methods

  context 'arbitrary account' do
    setup do
      @account = Account.new \
        [1,
         'elvis',
         'Presley',
         'Elvis Aaron',
         'med',
         'elvis@example.com',
         123,
         123,
         'geheim']
    end

    should 'takes a number for account.id' do
      assert_kind_of Integer, @account.id
    end

    should 'accept only Strings for uids' do
      assert_kind_of String, @account.uid
    end

    should 'accept only uids of length 5' do
      assert_equal 5, @account.uid.length
    end

    should 'accept only String for lastname' do
      assert_kind_of String, @account.lastname
    end

    should 'accept only String for firstname' do
      assert_kind_of String, @account.firstname
    end

    should 'accept only String for account_type' do
      assert_kind_of String, @account.account_type
    end

    should 'accept only String for mail' do
      assert_kind_of String, @account.mail
    end

    should 'accept only Integer for uidNumber' do
      assert_kind_of Integer, @account.uid_number
      assert_in_delta @account.uid_number, 1, 65000
    end

    should 'accept only Integer for gidNumber' do
      assert_kind_of Integer, @account.gid_number
      assert_in_delta @account.gid_number, 1, 65000
    end

    should 'accept only String for password' do
      assert_kind_of String, @account.password
    end
  end
end
