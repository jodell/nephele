require 'bundler'
Bundler.setup
require 'rake'
require 'rake/testtask'
require 'pp'

$: << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'nephele'

task :default => :'test:unit'

Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.pattern = 'test/tc_*'
  t.verbose = true
end

task :list do
  @cloud = Nephele.new \
    :service => :rackspace,
    :user => ENV['RACKSPACE_USER'],
    :key => ENV['RACKSPACE_KEY']
  pp @cloud.list
end
