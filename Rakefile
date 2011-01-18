require 'bundler'
Bundler.setup
require 'rake'
require 'rake/testtask'
require 'ap'
require 'irb'

$: << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'nephele'

task :default => :'test:unit'

Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.pattern = 'test/tc_*'
  t.verbose = true
end

def default_service
  ENV['NEPHELE_SERVICE_DEFAULT'].downcase.to_sym || :rackspace
end

def default
  @cloud ||= Nephele.new \
    :service => default_service,
    :user => ENV['RACKSPACE_USER'],
    :key => ENV['RACKSPACE_KEY']
end

task :list do
  default.list
end

task :create => [:image, :flavor, :count] do |t, args|
  default.create \
    :image => args[:image],
    :flavor => args[:flavor],
    :count => args[:count]
end

task :console do
  ARGV.clear
  default
  IRB.start
end
