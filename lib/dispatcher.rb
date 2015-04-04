#encoding: utf-8

require 'awesome_print'
require 'ruby-plsql'

require 'digest/sha1'
require 'base64'
require 'net/ldap'

class Dispatcher

  def initialize
    connect
    fetch_umlaute
  end

  def dispatch_first_line account: account
    model_first_line_from account
  end

  def dispatch_last_line account: account
    model_last_line_from account
  end

  def dispatch_delete_line account: account
    model_delete_from account
  end

  def dispatch_ldif_add_line account: account
    model_ldif_add_line_from account
  end

  def dispatch_ldif_delete_line account: account
    model_ldif_delete_line_from account
  end

  def adjust name
    return nil if name.nil?

    @umlaute.map do |set|
      name.gsub! set[:umlaut], set[:zeichenkette]
    end
    name
  end
private
  def model_first_line_from account
    name = ("#{adjust(account.firstname)} #{adjust(account.lastname)}").strip

    "#ADD6:#{account.uid}:" +
    "#{account.uid_number}:" +
    "#{account.gid_number}:" +
    "#{name}:" +
    "#{account.password}:"
  end

  def model_last_line_from account
    name = ("#{adjust(account.firstname)} #{adjust(account.lastname)}").strip

    "#MADR:#{account.uid}:" +
    "mlucom6:" +
    "#{name}:" +
    "#{account.mail}:"
  end

  def model_delete_from account
    "#DELETE:#{account.uid}:#{account.mail}"
  end

  def model_ldif_add_line_from account
    line = "dn: uid=#{account.uid},ou=mail,o=mlu,c=de\n"
    line += "sn: #{account.lastname}\n"

    if account.firstname.nil?
      line += "cn: #{account.lastname}\n"
    else
      line += "givenName: #{account.firstname}\n"
      line += "cn: #{account.firstname} #{account.lastname}\n"
    end
    line += "mail: #{account.mail}\n"
    #line += "userPassword: {SHA1}#{Base64.encode64(Digest::SHA1.hexdigest(account.password)).strip}\n"
    line += "userPassword: #{Net::LDAP::Password.generate(:sha, account.password)}\n"
    line += "objectClass: top\n"
    line += "objectClass: person\n"
    line += "objectClass: inetOrgPerson\n\n"
    line
  end

  def model_ldif_delete_line_from account
    "uid=#{account.uid},ou=mail,o=mlu,c=de"
  end

  def fetch_umlaute
    @umlaute = plsql.umlaute_tbl.all
  end

  def connect
    plsql.connection = OCI8.new \
      ENV['UMT_USER'],
      ENV['UMT_PASSWORD'],
      ENV['UMT_SID']
  end
end
