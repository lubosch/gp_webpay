require 'nokogiri'
require 'savon'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object'

require 'gp_webpay/version'
require 'gp_webpay/engine'
require 'gp_webpay/service'
require 'gp_webpay/openssl_security'
require 'gp_webpay/configuration'
require 'gp_webpay/response'

require 'gp_webpay/http/base_signed_request'
require 'gp_webpay/http/external_url'
require 'gp_webpay/http/http_response'
require 'gp_webpay/http/http_request'
require 'gp_webpay/http/create_order'
require 'gp_webpay/http/verify_card'
require 'gp_webpay/http/validate_result'

require 'gp_webpay/ws/ws_request'
require 'gp_webpay/ws/validate_result'
require 'gp_webpay/ws/ws_response'
require 'gp_webpay/ws/base_signed_request'

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
