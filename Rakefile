
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << %w(test lib test/factories )
  t.test_files = FileList["test/*_test.rb"]
end

task default: [:test]
