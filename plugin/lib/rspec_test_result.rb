require 'nokogiri'

class RspecTestResult
  attr_reader :html, :doc

  def initialize(html)
    @html = html
    @doc = Nokogiri::HTML(html)
  end

  def duration_str
    fetch_duration_node.inner_html.scan(/".*"/).first.gsub(/<\/?strong>/,"").gsub(/\"/,'')
  end

  def examples_count
    fetch_counts_str.match(/(\d+) example/)[1].to_i rescue 0
  end

  def failures_count
    fetch_counts_str.match(/(\d+) failure/)[1].to_i rescue 0
  end

  def pending_count
    fetch_counts_str.match(/(\d+) pending/)[1].to_i rescue 0
  end

  private

  def fetch_counts_str
    fetch_counts_node
      .inner_html.scan(/".*"/).first
  end

  def fetch_counts_node
    fetch_script_node_with_inner_pattern(/totals/)
  end

  def fetch_duration_node
    fetch_script_node_with_inner_pattern(/duration/)
  end

  def fetch_script_node_with_inner_pattern(pattern)
    doc.css("script")
      .select { |script| script.inner_html =~ pattern }
      .first
  end
end
