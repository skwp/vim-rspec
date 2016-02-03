# 
# Renders example group
#
# Parameters:
# example_group - an html representation of an rspec example_group from rspec output
#
class RSpecContextRenderer
  attr_reader :example_group


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
    example_group.examples.each do |example|
      render_spec_descriptor(example)
      FailureRenderer.new(example).render if example.failure?
    end
  end

  def render_spec_descriptor(example)
    puts "#{example.status_sign} #{example.header_text}"
  end
end
