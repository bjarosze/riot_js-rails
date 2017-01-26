require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

namespace :test do
  desc "Test with various versions of sprockets"
  task :sprockets_versions do
    sh "bash test/test_sprockets_versions.sh"
  end
end

