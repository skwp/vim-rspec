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

  describe '#examples_count' do
    it 'returns proper overall examples count' do
      expect(result.examples_count).to eq 15
    end
  end

  describe '#failures_count' do
    it 'returns proper failure examples count' do
      expect(result.failures_count).to eq 1
    end
  end

  describe '#pending_count' do
    it 'returns proper pending examples count' do
      expect(result.pending_count).to eq 0
    end
  end
end
