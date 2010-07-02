require 'rubygems'
gem 'rspec'
require 'spec'
require 'spec/autorun'
gem 'mocha'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

