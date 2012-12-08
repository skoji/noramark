# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/arti_mark'

describe ArtiMark do
  describe 'process_paragraph' do
    it 'should process a line' do
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph("the quick brown fox")
      expect(r.to_s).to eq("<p>the quick brown fox</p>")
    end
    it 'should process a line with open paren' do
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph("「そうはいっても")
      expect(r.to_s).to eq("<p class='noindent'>「そうはいっても</p>")
    end
  end
  describe 'process_paragraph_group' do
    it 'should process lines' do
      lines = %w(この文章は 「本当」のことを いっているとは かぎらない)
      artimark = ArtiMark::Document.new
      r = artimark.process_paragraph_group(lines).rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r[0]).to eq("<div class='pgroup'>")
      expect(r[1]).to eq("<p>この文章は</p>")
      expect(r[2]).to eq("<p class='noindent'>「本当」のことを</p>")
      expect(r[3]).to eq("<p>いっているとは</p>")
      expect(r[4]).to eq("<p>かぎらない</p>")
      expect(r[5]).to eq("</div>")
    end
  end
  describe 'convert' do
    it 'should convert simple paragraph' do
      text = "ここから、パラグラフがはじまります。\n二行目です。\n三行目です。\n\n\n ここから、次のパラグラフです。"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>ここから、パラグラフがはじまります。</p>") 
      expect(r.shift.strip).to eq("<p>二行目です。</p>") 
      expect(r.shift.strip).to eq("<p>三行目です。</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>ここから、次のパラグラフです。</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>") 
    end
  end
end
