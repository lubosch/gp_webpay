require 'faraday'
require 'faraday_middleware'

require 'gp_webpay/version'
require 'gp_webpay/configuration'

module GpWebpay
  @configuration = Configuration.new

  def self.config
    @configuration
  end

  def self.configure
    yield(@configuration)
  end

  def self.root
    File.dirname(__dir__)
  end

  class Error < StandardError
  end
end
