class Nephele::Rackspace < Nephele::Base
  def initialize(opts = {})
    super
  end

  def conn
    @conn ||= CloudServers::Connection.new \
      :username => @user,
      :api_key => @key
  end

  def list
    conn.servers
  end
end
