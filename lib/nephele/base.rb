class Nephele::Base
  attr_accessor :service, :key, :user
  attr_reader :conn

  def initialize(opts = {})
    @key = opts[:key] 
    @user = opts[:user]
    @service = opts[:service] || :rackspace
  end

  def list
    raise 'Subclass Responsibility'
  end

  def conn
    raise 'Subclass Responsibility'
  end

  def reset
    @conn = nil
    conn
  end
end
