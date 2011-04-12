require 'rubygems'

begin
  require 'bundler'
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/testtask'
require 'json'
require 'jeweler'
require 'ap'
require 'irb'
$: << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'nephele'

Jeweler::Tasks.new do |gem|
  gem.name = "nephele"
  gem.summary = %-Light administration utility for popular cloud services-
  gem.description = %-Light administration utility for popular cloud services-
  gem.email = 'jeffrey.odell@gmail.com'
  gem.authors = ["Jeffrey O'Dell"]
  gem.homepage  = 'https://github.com/jodell/nephele'
end

desc 'rubygems.org publishing'
task :push do
  ver = "nephele-#{File.read('VERSION')}"
  sh "gem build nephele.gemspec; gem push #{ver}.gem && rm #{ver}.gem"
end

task :default => :'test:unit'

task :tags do
  sh 'ctags -R *'
end

Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.pattern = 'test/tc_*'
  t.verbose = true
end

desc 'Key a host'
task :key, [:host] do |t, args|
  host = args[:host] =~ /(.*)@(.*)/ ? args[:host] : "root@#{args[:host]}"
  user = ENV['user'] || 'root'
  home = user == 'root' ? '/root' : "~#{user}"
  cmd = <<-EoC
ssh #{host} 'mkdir -p #{home}/.ssh && \
echo "#{my_default_key}" >> #{home}/.ssh/authorized_keys && \
chown -R #{user}:#{user} #{home}/.ssh'
EoC
  sh cmd
end

desc 'Start IRB with the relevant env'
task :console do
  ARGV.clear and IRB.start
end
