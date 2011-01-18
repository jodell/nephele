# Might scrap this
class Nephele::Node
  attr_reader :id, :type

  def initialize(opts)
    if opts.is_a? Hash
      @id = opts[:id]
      @type = opts[:type]
    else
      @id = opts.id
      @type = opts.class == CloudServers::Server ? :rackspace : nil
    end
  end

  def up?
    # TEMPORARY
    case @type
    when :rackspace
      CloudServers::Server.new(@id).status == 'ACTIVE'
    else
    end
  end
end
