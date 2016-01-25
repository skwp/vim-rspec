require 'nokogiri'
require_relative './string_util.rb'

class RspecExampleResult
  include ::StringUtil

  attr_reader :context

  def initialize(context)
    @context = context
  end

  def header_text
    context.css('span:first').first.inner_html
  end

  def html_class
    context['class'].gsub(/(?:example|spec) /,'')
  end

  def failure_message
    prepared_inner_html = context.css('div.message > pre').first.inner_html
      .gsub(/\n/,'').gsub(/\s+/,' ')
    unescape(prepared_inner_html)
  end

  def failure_location
    unescape(
      context.css('div.backtrace > pre').first.inner_html.split("\n").map do |line|
        "#{indent(line.strip)}"
      end.join("\n")
    )
  end

  def backtrace_lines
    context.css('pre.ruby > code').first.inner_html
      .scan(/(<span class="linenum">)(\d+)(<\/span>)(.*)/)
      .reject { |line| line[3] =~ ignore_line_if_matches }
  end

  private

  def ignore_line_if_matches
    /install syntax to get syntax highlighting/
  end
end
