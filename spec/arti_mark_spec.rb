require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/arti_mark'

describe ArtiMark do
  describe 'process_paragraph' do
    it 'should process a line' do
      artimark = ArtiMark::Document.new
      artimark.process_paragraph("the quick brown fox")
      expect(artimark.result).to eq("<p>the quick brown fox</p>\n")
    end
  end
end
