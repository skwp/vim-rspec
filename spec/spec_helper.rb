$TESTING=true

# require File.join(File.dirname(__FILE__), '../plugin/vim-rspec.rb')


# require 'vim-rspec'
require 'rspec/its'
require 'pry-nav'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

class RspecFileExampleProvider
  def self.not_all_passed
    File.join File.dirname(__FILE__), 'support/not_all_passed.html'
  end

  def self.example_group_path
    File.join File.dirname(__FILE__), 'support/example_group.html'
  end

  def self.passed_example_path
    File.join File.dirname(__FILE__), 'support/passed_example.html'
  end

  def self.failure_example_path
    File.join File.dirname(__FILE__), 'support/failure_example.html'
  end
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = "random"
end
