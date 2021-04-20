ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_ROOT'] = File.expand_path('dummy', __dir__)
require File.expand_path('dummy/config/environment', __dir__)

require 'rspec/rails'
require 'savon/mock/spec_helper'

Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.include GpWebpay::Engine.routes.url_helpers, type: :controller
  config.include Savon::SpecHelper, type: :webservice

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
