# encoding: utf-8

require "ruby-plsql"

class Idm

  def initialize
    connect
  end

  def fetch_add_sets since: nil
    records = nil
    plsql.mail_pkg.fetchAddSets(since) { |c| records = c.fetch_all }

    @accounts = records.map do |record|
      cast_to_add_account(record)
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
