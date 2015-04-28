# encoding: utf-8

# Diese Klasse ist der Konnektor hin zum Groupwise.
#
# exist_mail? -> bool
# exist_uid? -> bool

require "net/ldap"

class Groupwise

  def initialize
    connect
  end

  def add account: nil
    if uid_not_exist?(uid: account.uid)
      dn = "uid=#{account.uid},#{ENV['GWLDAP_BASEDN']}"
      @ldap.add dn: dn, attributes: account.to_ldif
      puts "Account #{account.uid} in den Groupwise-LDAP eingetragen."
    end
  end

  def exist_mail? mail: mail
    filter = Net::LDAP::Filter.eq 'mail', mail
    basedn = ENV['GWLDAP_BASEDN']
    attributes = ['dn']

    counter = 0
    @ldap.search(base: basedn, filter: filter, attributes: attributes) do |entry|
      counter += 1
    end

    counter > 0 ? true : false
  end

  def exist_uid? uid: uid
    filter = Net::LDAP::Filter.eq 'uid', uid
    basedn = ENV['GWLDAP_BASEDN']
    attributes = ['dn']

    counter = 0
    @ldap.search(base: basedn, filter: filter, attributes: attributes) do |entry|
      counter += 1
    end

    counter > 0 ? true : false
  end

  def uid_not_exist? uid: uid
    !exist_uid?(uid: uid)
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
