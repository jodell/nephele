require 'cloudservers'

module Nephele
  SERVICES = [:rackspace, :ec2].freeze
  require 'nephele/base'
  require 'nephele/rackspace'

  # Factory for service objects
  def self.new(opts)
    case opts[:service]
    when :rackspace
      Nephele::Rackspace.new :key => opts[:key], :user => opts[:user]
    when :ec2
      raise 'Not Implemented Yet'
    else
      raise "Unsupported service, expected one of #{SERVICES * ', '}"
    end
  end
end
