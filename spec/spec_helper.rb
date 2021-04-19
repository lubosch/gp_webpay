# require_relative 'support/simplecov'
#
# require 'bundler/setup'
# require 'gp_webpay'
# require 'webmock/rspec'
#
# RSpec.configure do |config|
#   # Enable flags like --only-failures and --next-failure
#   config.example_status_persistence_file_path = '.rspec_status'
#
#   # Disable RSpec exposing methods globally on `Module` and `main`
#   config.disable_monkey_patching!
#
#   config.expect_with :rspec do |c|
#     c.syntax = :expect
#   end
# end
#
# GpWebpay.configure do |config|
#   config.mount_at = '/'
#   config.parent_controller = 'ApplicationController'
#   config.orders_controller = 'GpWebpay::OrdersTestController'
#   config.add_configuration(merchant_number: '11111111') do |merchant_config|
#     merchant_config.merchant_number = '11111111'
#     merchant_config.merchant_pem = "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----"
#     merchant_config.merchant_password = 'Password'
#     merchant_config.gpe_pem = "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----"
#     merchant_config.provider = '3040'
#   end
# end
require 'bundler/setup'
# require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
ENV["RAILS_ROOT"] = File.expand_path("../dummy",  __FILE__)
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'

# require 'gp_webpay'
require 'webmock/rspec'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include GpWebpay::Engine.routes.url_helpers, type: :controller

  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end

# GpWebpay.configure do |config|
#   config.mount_at = '/'
#   config.parent_controller = 'ApplicationController'
#   config.orders_controller = 'OrdersTestController'
#   config.add_configuration(merchant_number: '11111111') do |merchant_config|
#     merchant_config.merchant_number = '11111111'
#     merchant_config.merchant_pem = "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----"
#     merchant_config.merchant_password = 'Password'
#     merchant_config.gpe_pem = "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----"
#     merchant_config.provider = '3040'
#   end
# end
