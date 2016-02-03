require 'spec_helper'
require './plugin/lib/rspec_example_group_result'

describe RspecExampleGroupResult do
  subject(:result) { described_class.new(doc) }

  let(:doc) { Nokogiri::HTML(input_html) }
  let(:input_html) { File.read(RspecFileExampleProvider.example_group_path) }

  describe '#header_text' do
    it 'returns proper string' do
      expect(result.header_text).to eq 'EmptyUser'
    end
  end

  describe '#examples' do
    it 'returns proper number of examples' do
      expect(result.examples.count).to eq 7
    end

    it 'returns wraps examples' do
      expect(result.examples.first).to be_kind_of(RspecExampleResult)
    end
  end
end
