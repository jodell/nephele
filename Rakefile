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
  {
    :service => ENV['NEPHELE_SERVICE_DEFAULT'].downcase.to_sym || :rackspace,
    :user    => ENV['RACKSPACE_USER'],
    :key     => ENV['RACKSPACE_KEY']
  }
end

def default
  @cloud ||= Nephele.new default_service
end

desc 'List available servers'
task :list do
  ap default.servers
end

desc 'Show node statuses'
task :status do
  puts default.status
end

desc 'Creates a node with name, image name, flavor, optional count:  `rake create[mybox,oberon,512 server,3]`'
task :create, [:name, :image, :flavor, :count] do |t, args|
  (args[:count].to_i || 1).times do |i|
    default.create \
      :name   => "#{args[:name]}#{i + 1}",
      :image  => args[:image],
      :flavor => args[:flavor]
  end
end

desc 'Destroy a node with name `rake destroy[foo]`'
task :destroy, [:name] do |t, args|
  # FIXME
  default.send(args[:name]).delete!
end

desc 'Start IRB with the relevant env'
task :console do
  ARGV.clear
  default
  IRB.start
end
