# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/arti_mark'

describe ArtiMark do
  describe 'process_paragraph' do
    it 'should process a line' do
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph("the quick brown fox")
      expect(r).to eq("<p>the quick brown fox</p>\n")
    end
    it 'should process a line with open paren' do
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph("「そうはいっても")
      expect(r).to eq("<p class=\"noindent\">「そうはいっても</p>\n")
    end
  end
end
