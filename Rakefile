require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require 'ap'
require 'irb'

$: << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'nephele'

task :default => :'test:unit'

task :tags do 
  sh 'ctags -R *'
end

Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.pattern = 'test/tc_*'
  t.verbose = true
end

def default_service
  {
    :service => ENV['NEPHELE_SERVICE_DEFAULT'] && 
                  ENV['NEPHELE_SERVICE_DEFAULT'].downcase.to_sym || 
                    :rackspace,
    :user    => ENV['RACKSPACE_USER'],
    :key     => ENV['RACKSPACE_KEY']
  }
end

def default
  @@default ||= Nephele.new default_service
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

def personality
  if ENV['personality']
    acc = {}
    ENV['personality'].split(',').each_slice(2) { |(k, v)| acc[k] = v }
    acc
  else
    { generate_key_file => '/root/.ssh/authorized_keys' }
  end
end

def generate_key_file
  '/tmp/nephele_key_file'.tap do |file| File.open(file, 'w') { |f| f << my_default_key }; end
end

def my_default_key
  File.read(File.expand_path('~/.ssh/id_dsa.pub'))
end

desc "Creates a node with name, image name, flavor, optional count:  `rake create[mybox,oberon,'512 server'] count=4`"
task :create, [:name, :image, :flavor] do |t, args|
  (ENV['count'] || 1).to_i.times do |i|
    @node = default.create \
      :name        => args[:name] + "#{ENV['count'] ? i + 1 : ''}",
      :image       => lookup(args[:image]),
      :flavor      => args[:flavor],
      :personality => personality
  end
end

# FIXME
def lookup(image)
  case image
  when /lucid/
    "Ubuntu 10.04 LTS (lucid)"
  else
    image
  end
end

JODELL_CHEF_BOOTSTRAPPER = 'https://github.com/jodell/cookbooks/raw/master/bin/bootstrap.sh'

desc 'Create a VM and run a chef bootstrapper, optional recipe arg'
task :bootstrap, [:name, :image, :flavor] => :create do |t, args|
  sh %-ssh root@#{@node.addresses[:public]} "curl #{JODELL_CHEF_BOOTSTRAPPER } | bash"-
  sh %{ssh root@#{@node.addresses[:public]} "cd -P /var/chef/cookbooks && rake run[#{ENV['recipe']}]"} if ENV['recipe']
end

desc 'Destroy, bootstrap'
task :restrap, [:name, :image, :flavor] => [:destroy, :create]

desc 'Destroy a node with name `rake destroy[foo]`'
task :destroy, [:name] do |t, args|
  default.server_objs.find { |s| s.name == args[:name] }.delete!
end

desc 'Start IRB with the relevant env'
task :console do
  ARGV.clear and IRB.start
end
