class Nephele::Base
  attr_accessor :service, :key, :user
  attr_reader :conn, :nodes

  def initialize(opts = {})
    @nodes = []
    @key = opts[:key] 
    @user = opts[:user]
    @service = opts[:service] || :rackspace
  end

  # After a verified connection, the service class should call this to
  # populate the list of nodes
  #
  def populate!
    raise 'Subclass Responsibility'
  end

  def conn
    raise 'Subclass Responsibility'
  end

  def create
    raise 'Subclass Responsibility'
  end

  def list
    @nodes
  end

  def reset
    @conn = nil
    conn
  end

  def method_missing(meth, *args)
    if conn.respond_to? meth
      conn.send meth, *args
    else
      super
    end
  end
end
