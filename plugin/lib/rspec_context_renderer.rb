# 
# Renders example group
#
# Parameters:
# example_group - an html representation of an rspec example_group from rspec output
#
class RSpecContextRenderer
  attr_reader :example_group

  CLASSES = {"passed"=>"+","failed"=>"-","not_implemented"=>"#"}

  def initialize(example_group)
    @example_group = example_group
  end

  def render
    render_example_group_header
    render_specs
    puts " "
  end

  private

  def render_example_group_header
    puts "[#{example_group.header_text}]"
  end

  def render_specs
    example_group.eaxmples.each do |example|
      render_spec_descriptor(example)
    end
    (example_group/"dd").each do |dd|
      FailureRenderer.new(dd/"div[@class~='failure']") if dd[:class] =~ /failed/
    end
  end

  def render_spec_descriptor(example)
    txt = (dd/"span:first").inner_html
    clazz = dd[:class].gsub(/(?:example|spec) /,'')
    puts "#{CLASSES[clazz]} #{txt}"
  end
end
