require_relative 'string_util'

class FailureRenderer
  include StringUtil

  attr_reader :example

  def initialize(example)
    @example = example
  end

  def render
    puts failure_message
    puts failure_location
    puts backtrace_details
  end

  private

  def failure_message
    indent(unescape(example.failure_message))
  end

  def failure_location
    unescape(
      example.failure_location.split("\n")
      .map { |line| "#{indent(line.strip)}" }
      .join("\n")
    )
  end

  def backtrace_details
    unescape(
      example.backtrace_lines.map do |elem|
        linenum = elem[1]
        code = elem[3].chomp
        code = strip_html_spans(code)
        "  #{linenum}: #{code}\n"
      end.join
    )
  end
end
