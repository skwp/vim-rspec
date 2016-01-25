require 'spec_helper'
require './plugin/lib/rspec_example_result'

describe RspecExampleResult do
  subject(:result) { described_class.new(doc) } 

  let(:doc) { Nokogiri::HTML.fragment(input_html).css('dd').first }
  let(:input_html) { File.read(RspecFileExampleProvider.passed_example_path) }

  describe '#header_text' do
    it 'returns proper text' do
      expect(result.header_text).to eq 'should respond to #member?'
    end
  end

  context 'when passed example' do
    describe '#html_class' do
      it 'returns proper value' do
        expect(result.html_class).to eq 'passed'
      end
    end
  end

  context 'when failure example' do
    let(:input_html) { File.read(RspecFileExampleProvider.failure_example_path) }

    describe '#html_class' do
      it 'returns proper value' do
        expect(result.html_class).to eq 'failed'
      end
    end

    describe '#failure_message' do
      it 'returns proper value' do
        expect(result.failure_message).to eq 'expected #<EmptyUser:0x007f95646fdaf0 @role="guest", @id=0> to respond to :forget_me2!'
      end
    end

    describe '#failure_location' do
      it 'returns proper value' do
        expect(result.failure_location).to eq "  ./spec/app/core/empty_user_spec.rb:18:in `block (2 levels) in <top (required)>'"
      end
    end

    describe '#backtrace_lines' do
      it 'returns proper values' do
        expect(result.backtrace_lines).to eq [["<span class=\"linenum\">", "16", "</span>", "  <span class=\"keyword\">end</span>"], ["<span class=\"linenum\">", "17", "</span>", ""], ["<span class=\"linenum\">", "18", "</span>", "  it { is_expected.to respond_to <span class=\"symbol\">:forget_me2!</span> }</span>"], ["<span class=\"linenum\">", "19", "</span>", "  it { is_expected.to respond_to <span class=\"symbol\">:force_forget_me!</span> }"], ["<span class=\"linenum\">", "20", "</span>", "<span class=\"keyword\">end</span>"]]
      end
    end
  end
end
