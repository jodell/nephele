require 'tempfile'
require 'net/http'

class Nephele::Rackspace < Nephele::Base
  attr_reader :nodes
  attr_accessor :timeout

  def initialize(opts = {})
    super
    @timeout = opts[:timeout] || 180
    populate!
  end

  def conn
    @conn ||= CloudServers::Connection.new \
      :username => @user,
      :api_key => @key
  end

  def populate!
    server_objs.each { |n| register!(n) }
  end

  def register!(node)
    @nodes << Nephele::Node.new(node)
    # methods can't start with a leading digit
    meth = node.name.match(/^(\d)+/) ? "_#{node.name}" : node.name
    self.class.send(:define_method, meth.gsub(/\./, '_').to_sym) do
      CloudServers::Server.new(conn, node.id)
    end
  end

  def create(opts)
    rack_node = conn.create_server \
      :name        => opts[:name],
      :imageId     => images_id_for_name(opts[:image]),
      :flavorId    => flavors_id_for_name(opts[:flavor]),
      :personality => opts[:personality] || ''
    puts "Server pass: #{rack_node.adminPass}, ip #{rack_node.addresses[:public].first}"
    register!(rack_node)
    rack_node
  end

  def build_and_wait(opts)
    rack_node = create(opts)
    t1 = Time.now
    begin
      Timeout::timeout(@timeout) do
        sleep 2 while rack_node.refresh && rack_node.status != 'ACTIVE'
        sleep 2 while !(TCPSocket.new(rack_node.addresses[:public].first, 22) rescue nil)
      end
    rescue Timeout::Error
      puts "Server creation timed out after #{@timeout} seconds!"
    end
    puts "#{rack_node.status}: #{Time.now - t1}" if ENV['verbose']
    rack_node
  end

  def destroy(opts)
    id = servers_id_for_name(opts[:name])
    CloudServers::Server.new(conn, id).delete!
    @nodes.delete_if { |n| n.id == id }
  end

  def delete_image(image)
    del = image_objs.find { |i| i.name == image }
    del.delete!
  end

  def max_size_for(field)
    server_objs.inject(0) { |acc, so| acc = [acc, so.send(field.to_sym).to_s.length].max }
  end

  def status
    max_name = max_size_for 'name'
    max_status = max_size_for 'status'
    max_progress = max_size_for 'progress'
    header = [
      'NAME'.ljust(max_name),
      'STATUS'.ljust(max_status),
      '-%-'.ljust(max_progress),
      'Kind'.ljust(10),
      "Public IP\n"
    ] * ' '
    info = server_objs.inject('') do |acc, s|
      acc += [
        s.name.ljust(max_name),
        s.status.ljust(max_status),
        s.progress.to_s.ljust(max_progress),
        s.flavor.name.ljust(10),
        "#{s.addresses[:public].first}\n"
      ] * ' '
    end
    header + info
  end

  def provisioning?
    server_objs.any? { |s| s.status != 'ACTIVE' }
  end

  [:servers, :flavors, :images].each do |sym|
    define_method "#{sym}_id_for_name" do |name|
      _id_for_name(sym, name)
    end
  end

  def _id_for_name(obj, name)
    conn.send(obj.to_sym).find { |o| o[:name] == name }[:id]
  end

  def server_objs
    conn.servers.inject([]) do |acc, info|
      acc << CloudServers::Server.new(conn, info[:id]); acc
    end
  end

  def image_objs
    conn.images.inject([]) do |acc, info|
      acc << CloudServers::Image.new(conn, info[:id]); acc
    end
  end

  def self.image_lookup(name)
    case name
    when /^lucid$/
      "Ubuntu 10.04 LTS (lucid)"
    else
      name
    end
  end
end

module Nephele::Rackspace::Util
  class << self
    def personality(personality)
      if personality == :default
        base = { my_default_key   => '/root/.ssh/authorized_keys',
                 known_hosts_file => '/root/.ssh/known_hosts' }
        base.merge!({ vpn_pass_file => '/root/.vpnpass' }) if vpn_pass_file
        base.merge!({ nephele_info_file => '/etc/nephele/info' })
      else
        acc = {}
        personality.split(',').each_slice(2) { |(k, v)| acc[k] = v }
        acc
      end
    end

    def my_default_key(keyfile = File.expand_path('~/.ssh/id_dsa.pub'))
      return keyfile if File.exists?(keyfile)
      alt = File.expand_path('~/.ssh/id_rsa.pub')
      return alt if File.exists?(alt)
    end

    def known_hosts_file
      File.open('/tmp/known_hosts.nephele', 'w') { |f| f << known_hosts; f.path }
    end

    def vpn_pass_file(passfile = File.expand_path('~/.vpnpass'))
      File.exists?(passfile) && passfile
    end

    def nephele_info_file
      File.open("/tmp/nephele-meta", 'w') do |f|
        f << "# Nephele Creation: #{Time.now}\n# Creator: #{ENV['USER']}"
        f.path
      end
    end

    # Github
    def known_hosts
      <<-EoS
|1|xLwg2PqKMACZR+6X0OH9rx66p1I=|xR01sH66lqU3PejWe+8J0EWulb0= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|juutFPHnSpo61K6I1Y7XnKB07yI=|u/ZYrJrAdgQ1G/cd48si2avBHTQ= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EoS
    end
  end
end
