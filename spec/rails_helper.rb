ENV["RAILS_ENV"] = "test"

require "factory_bot_rails"
require "database_cleaner"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "openai_assistant"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
