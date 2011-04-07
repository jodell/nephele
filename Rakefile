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
  gem.executables = ['nephele']
  gem.homepage  = 'https://github.com/jodell/nephele'
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

def default
  @@default ||= Nephele.new :service => :default
end

desc 'List available servers'
task :servers do
  ap default.servers.map { |i| i[:name] }
end

task :list => :servers

desc 'List available images'
task :images do
  ap default.images.map { |i| i[:name] }
end

desc 'List available flavors'
task :flavors do
  ap default.flavors.map { |i| i[:name] }
end

desc 'Show node statuses'
task :status do
  puts default.status
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

desc 'Reset the node password (performs a reoot)'
task :password, [:node, :pass] do |t, args|
  default.server_objs.find { |s| s.name == args[:node] }.update(:adminPass => args[:pass])
end

desc 'Save an image of the node'
task :save, [:node, :name] do |t, args|
  default.server_objs.find { |s| s.name == args[:node] }.create_image args[:name]
end

desc "Creates a node with name, image name, flavor, optional count:  `rake create[mybox,oberon,'512 server'] count=4`"
task :create, [:name, :image, :flavor] do |t, args|
  (ENV['count'] || 1).to_i.times do |i|
    @node = default.create \
      :name        => args[:name] + "#{ENV['count'] ? i + 1 : ''}",
      :image       => Nephele::Rackspace.image_lookup(args[:image]),
      :flavor      => args[:flavor],
      :personality => Nephele::Rackspace::Util.personality(ENV['personality'] || :default)
  end
end

JODELL_CHEF_BOOTSTRAPPER = 'https://github.com/jodell/cookbooks/raw/master/bin/bootstrap.sh'

desc 'Create a VM and run a chef bootstrapper, optional recipe, bootstrap, cookbooks args'
task :bootstrap, [:name, :image, :flavor] => :create do |t, args|
  puts "Bootstrapping: #{args[:name]}..."
  bootstrapper = ENV['bootstrap'] || JODELL_CHEF_BOOTSTRAPPER
  alt = ENV['cookbooks']
  sh %-time ssh root@#{@node.addresses[:public]} "curl #{bootstrapper} > boot && chmod +x boot && ./boot #{alt}"-
  sh %{time ssh root@#{@node.addresses[:public]} "cd -P /var/chef/cookbooks && rake run[#{ENV['recipe']}]"} if ENV['recipe']
end

desc 'Destroy, bootstrap'
task :restrap, [:name, :image, :flavor] => [:destroy, :bootstrap]

desc 'Destroy a node with name `rake destroy[foo]`'
task :destroy, [:name] do |t, args|
  puts "Destroying: #{args[:name]}"
  default.server_objs.find { |s| s.name == args[:name] }.delete!
end

desc 'Start IRB with the relevant env'
task :console do
  ARGV.clear and IRB.start
end
