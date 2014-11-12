#encoding: utf-8

require 'awesome_print'
require 'ruby-plsql'

class Dispatcher

  def initialize
    connect
    fetch_umlaute
  end

  def dispatch_first_line account
    model_first_line_from(account)
  end

  def dispatch_last_line account
    model_last_line_from(account)
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

  def adjust name
    return nil if name.nil?

    @umlaute.map do |set|
      name.gsub! set[:umlaut], set[:zeichenkette]
    end
    name
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
