require 'cloudservers'

module Nephele
  SERVICES = [:rackspace, :ec2].freeze
  require 'nephele/base'
  require 'nephele/node'
  require 'nephele/rackspace'

  # Factory for service objects
  def self.new(opts)
    case opts[:service]
    when :rackspace
      Nephele::Rackspace.new :key => opts[:key], :user => opts[:user]
    when :ec2
      raise 'Not Implemented Yet'
    when :default
      Nephele::Rackspace.new default
    else
      raise "Unsupported service, expected one of #{SERVICES * ', '}"
    end
  end

  def self.default
    { :service => ENV['NEPHELE_SERVICE_DEFAULT'] &&
                    ENV['NEPHELE_SERVICE_DEFAULT'].downcase.to_sym ||
                      :rackspace,
      :user    => ENV['RACKSPACE_USER'],
      :key     => ENV['RACKSPACE_KEY'] }
  end
end
