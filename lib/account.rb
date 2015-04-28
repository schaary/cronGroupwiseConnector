# encoding: utf-8

require 'net/ldap'

class Account
  attr_accessor :id, :firstname, :lastname, :account_type, :uid, :uid_number,
                :gid_number, :mail, :password

  def initialize record
    @id = record[0].to_i
    @uid = record[1].strip
    @lastname = record[2].strip
    @firstname = record[3].to_s.strip
    @account_type = record[5].strip
    @mail = record[6].strip
    @uid_number = record[7].to_i
    @gid_number = record[8].to_i
    @password = record[9].strip
  end

  def displayname
    "#{firstname} #{lastname}".strip
  end

  def checksum
    Digest::SHA1.hexdigest "#{@uid}#{displayname}#{@mail}"
  end

  def to_ldif
    ldif_hash = {
      sn: @lastname,
      cn: displayname,
      mail: @mail,
      uid: @uid,
      userPassword: Net::LDAP::Password.generate(:sha, @password),
      carLicense: checksum,
      objectClass: ["top","person","inetOrgPerson"]
    }

    if 'f' != @account_type
      ldif_hash = ldif_hash.merge({ givenName: @firstname })
    end

    ldif_hash
  end
end
