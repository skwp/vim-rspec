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
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = "random"
end
