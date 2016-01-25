require 'spec_helper'
require './plugin/lib/rspec_test_result'

describe RspecTestResult do
  subject(:result) { described_class.new(input_html) }

  let(:input_html) { File.read(RspecFileExampleProvider.not_all_passed) }

  describe '#duration_str' do
    it 'returns proper duration string' do
      expect(result.duration_str).to eq 'Finished in 0.80876 seconds'
    end
  end
end
