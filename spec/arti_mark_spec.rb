# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/arti_mark'

describe ArtiMark do
  describe 'process_paragraph' do
    it 'should process a line' do
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph("the quick brown fox")
      expect(r).to eq("<p>the quick brown fox</p>")
    end
    it 'should process a line with open paren' do
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph("「そうはいっても")
      expect(r).to eq("<p class='noindent'>「そうはいっても</p>")
    end
  end
  describe 'process_paragraph_group' do
    it 'should process lines' do
      lines = %w(この文章は 「本当」のことを いっているとは かぎらない)
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph_group(lines)
      expect(r[0]).to eq("<div class='pgroup'>")
      expect(r[1]).to eq("<p>この文章は</p>")
      expect(r[2]).to eq("<p class='noindent'>「本当」のことを</p>")
      expect(r[3]).to eq("<p>いっているとは</p>")
      expect(r[4]).to eq("<p>かぎらない</p>")
      expect(r[5]).to eq("</div>")
    end
  end
end
