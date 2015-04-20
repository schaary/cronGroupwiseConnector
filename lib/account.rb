# encoding: utf-8

require 'net/ldap'

class Account
  attr_accessor :id, :firstname, :lastname, :account_type, :uid, :uid_number,
                :gid_number, :mail, :password

  def initialize record
    @id = record[0].to_i
    @uid = record[1].strip
    @lastname = record[2].strip
    @firstname = record[3]
    @account_type = record[4].strip
    @mail = record[5].strip
    @uid_number = record[6].to_i
    @gid_number = record[7].to_i
    @password = record[8].strip
  end

  def to_ldif
    line = "dn: uid=#{@uid},ou=mail,o=mlu,c=de\n"
    line += "sn: #{@lastname}\n"

    if 'f' == @account_type
      line += "cn: #{@lastname}\n"
    else
      line += "givenName: #{@firstname}\n"
      line += "cn: #{@firstname} #{@lastname}\n"
    end
    line += "mail: #{@mail}\n"
    line += "userPassword: #{Net::LDAP::Password.generate(:sha, @password)}\n"
    line += "objectClass: top\n"
    line += "objectClass: person\n"
    line += "objectClass: inetOrgPerson\n\n"
    ap line
    line

  end
end
