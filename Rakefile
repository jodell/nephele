require 'bundler'
Bundler.setup
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

desc 'Reset the node password (performs a reboot)'
task :password, [:node, :pass] do |t, args|
  default.server_objs.find { |s| s.name == args[:name] }.update(:password => args[:pass])
end

desc 'Save an image of the node'
task :save, [:node, :name] do |t, args|
  default.server_objs.find { |s| s.name == args[:name] }.create_image args[:name]
end

desc "Creates a node with name, image name, flavor, optional count:  `rake create[mybox,oberon,'512 server'] count=4`"
task :create, [:name, :image, :flavor] do |t, args|
  (ENV['count'] || 1).to_i.times do |i|
    default.create \
      :name   => args[:name] + "#{ENV['count'] ? i + 1 : ''}",
      :image  => args[:image],
      :flavor => args[:flavor]
  end
end

desc 'Destroy a node with name `rake destroy[foo]`'
task :destroy, [:name] do |t, args|
  default.server_objs.find { |s| s.name == args[:name] }.delete!
end

desc 'Start IRB with the relevant env'
task :console do
  ARGV.clear and IRB.start
end
