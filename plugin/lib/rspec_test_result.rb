require 'nokogiri'

class RspecTestResult
  attr_reader :html, :doc

  def initialize(html)
    @html = html
    @doc = Nokogiri::HTML(html)
  end

  def duration_str
    fetch_duration_node
      .inner_html.scan(/".*"/).first.gsub(/<\/?strong>/,"").gsub(/\"/,'')
  end

  private

  def fetch_duration_node
    doc.css("script")
      .select { |script| script.inner_html =~ /duration/ }
      .first
  end
end
