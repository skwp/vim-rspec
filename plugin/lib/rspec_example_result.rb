require 'nokogiri'
require_relative './string_util.rb'

class RspecExampleResult
  include ::StringUtil

  CLASSES_TO_SIGN_MAPPING = {"passed"=>"+","failed"=>"-","not_implemented"=>"#"}

  attr_reader :context

  def initialize(context)
    @context = context
  end

  def failure?
    context['class'] =~ /failed/
  end

  def header_text
    context.css('span:first').first.inner_html
  end

  def html_class
    context['class'].gsub(/(?:example|spec) /,'')
  end

  def failure_message
    context.css('div.message > pre').first.inner_html
      .gsub(/\n/,'').gsub(/\s+/,' ')
  end

  def failure_location
    unescape(
      context.css('div.backtrace > pre').first.inner_html.split("\n").map do |line|
        "#{indent(line.strip)}"
      end.join("\n")
    )
    context.css('div.backtrace > pre').first.inner_html
  end

  def backtrace_lines
    context.css('pre.ruby > code').first.inner_html
      .scan(/(<span class="linenum">)(\d+)(<\/span>)(.*)/)
      .reject { |line| line[3] =~ ignore_line_if_matches }
  end

  def status_sign
    CLASSES_TO_SIGN_MAPPING[html_class]
  end

  private

  def ignore_line_if_matches
    /install syntax to get syntax highlighting/
  end
end
