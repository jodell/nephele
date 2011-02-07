class Nephele::Rackspace < Nephele::Base
  attr_reader :nodes

  def initialize(opts = {})
    super
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
    puts "Server pass: #{rack_node.adminPass}, ip #{rack_node.addresses[:public]}"
    register!(rack_node)
    rack_node
  end

  def destroy(opts)
    id = servers_id_for_name(opts[:name])
    CloudServers::Server.new(conn, id).delete!
    @nodes.delete_if { |n| n.id == id }
  end

  def status
    header = "#{'NAME'.ljust(20)} #{'STATUS'.ljust(6)} #{'-%-'.ljust(3)} #{'Kind'.ljust(10)} Public IP\n"
    info = server_objs.inject('') do |acc, s|
      acc += "#{s.name.ljust(20)} #{s.status.ljust(6)} #{s.progress.to_s.ljust(3)} #{s.flavor.name.ljust(10)} #{s.addresses[:public]}\n"
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
end
