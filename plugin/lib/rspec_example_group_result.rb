require 'nokogiri'
require_relative 'rspec_example_result'

class RspecExampleGroupResult
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def header_text
    fetch_header_node.inner_html
  end

  def examples
    context.css('dd').map do |context|
      RspecExampleResult.new(context)
    end
  end

  private

  def fetch_header_node
    context.css('dl dt').first
  end
end
