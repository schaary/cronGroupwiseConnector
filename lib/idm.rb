# encoding: utf-8

require "ruby-plsql"
require "pry"
require_relative "./account"

class Idm

  def initialize
    connect
  end

  def fetch_add_sets since: nil
    records = nil
    plsql.mail_pkg.fetchAddSets(since) { |c| records = c.fetch_all }

    if 0 < records.count
      puts "IDM einlesen: ... #{records.count} Accounts eingelesen."
    else
      puts "IDM einlesen: ... es wurden keine neuen Accounts gefunden."
    end

    records.reduce([]) do |accounts, record|
      accounts << Account.new(record)
    end
  end

  def last_run service: nil
    if :push == service then
      plsql.ma_pkg.lastRun(2,4)
    end
  end

  def write_log service: nil
    if :push == service
      return_value = plsql.ma_pkg.writeLog(2, 4, 0)
    end
  end

private
  def connect
    plsql.connection ||= OCI8.new \
      ENV['IDM_USERNAME'],
      ENV['IDM_PASSWORD'],
      ENV['IDM_SID']
  end
end
