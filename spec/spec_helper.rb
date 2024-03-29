ENV["RAILS_ENV"] ||= 'test'
require "#{File.dirname(__FILE__)}/../test/dummy/config/environment"
require 'ym_core/spec_helper'
require 'shoulda/matchers'

FactoryGirl.reload
require "#{File.dirname(__FILE__)}/../features/support/factories"

require "support/webmock"

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
end
