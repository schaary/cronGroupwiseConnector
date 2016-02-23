# encoding: utf-8

# Diese Klasse ist der Konnektor hin zum Groupwise.
#
# exist_mail? -> bool
# exist_uid? -> bool

require "net/ldap"
require "awesome_print"

class Groupwise

  def initialize
    connect
  end

  def add(account:)
    if uid_not_exist?(uid: account.uid)
      dn = "uid=#{account.uid},#{ENV['GWLDAP_BASEDN']}"
      puts "hier to ldif"
      @ldap.add dn: dn, attributes: account.to_ldif
      puts "Account #{account.uid} in den Groupwise-LDAP eingetragen."
    end
  end

  def update(account:)
    if uid_exist?(uid: account.uid)
      dn = "uid=#{account.uid},#{ENV['GWLDAP_BASEDN']}"
      operations = [
        [:replace, :sn, account.lastname],
        [:replace, :cn, account.displayname],
        [:replace, :mail, account.mail],
        [:replace, :carlicense, account.checksum]
      ]

      if "f" != account.account_type
        operations << [:replace, :givenname, account.firstname]
      end

      @ldap.modify dn: dn, operations: operations

      ap operations
      puts "Account #{account.uid} in den Groupwise-LDAP eingetragen."
    end
  end

  def exist_mail?(mail:)
    filter = Net::LDAP::Filter.eq 'mail', mail
    basedn = ENV['GWLDAP_BASEDN']
    attributes = ['dn']

    counter = 0
    @ldap.search(base: basedn, filter: filter, attributes: attributes) do |entry|
      counter += 1
    end

    counter > 0 ? true : false
  end

  def uid_exist?(uid:)
    filter = Net::LDAP::Filter.eq 'uid', uid
    basedn = ENV['GWLDAP_BASEDN']
    attributes = ['dn']

    counter = 0
    @ldap.search(base: basedn, filter: filter, attributes: attributes) do |entry|
      counter += 1
    end

    counter > 0 ? true : false
  end

  def uid_not_exist?(uid:)
    !uid_exist?(uid: uid)
  end

private
  def connect
    @ldap = Net::LDAP.new(
      host: ENV['GWLDAP_HOST'],
      port: ENV['GWLDAP_PORT'].to_i,
      auth: {
        method: :simple,
        username: ENV['GWLDAP_USER'],
        password: ENV['GWLDAP_PASSWORD']
      }
    )
  end
end
