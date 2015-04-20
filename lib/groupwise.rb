# encoding: utf-8

# Diese Klasse ist der Konnektor hin zum Groupwise.
#
# exist_address? -> bool
# exist_uid? -> bool

require "net/ldap"
require "pry"

class Groupwise

  def initialize
    connect
  end

  def exist_mail? mail: mail
    filter = Net::LDAP::Filter.eq 'mail', mail
    basedn = "ou=mail,o=mlu,c=de"
    attributes = ['dn']

    counter = 0
    @ldap.search(base: basedn, filter: filter, attributes: attributes) do |entry|
      counter += 1
    end

    counter > 0 ? true : false
  end

  def exist_uid? uid: uid
    filter = Net::LDAP::Filter.eq 'uid', uid
    basedn = "ou=mail,o=mlu,c=de"
    attributes = ['dn']

    counter = 0
    @ldap.search(base: basedn, filter: filter, attributes: attributes) do |entry|
      counter += 1
    end

    counter > 0 ? true : false
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
