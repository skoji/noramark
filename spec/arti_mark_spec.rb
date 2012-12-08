# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/arti_mark'

describe ArtiMark do
  describe 'convert' do
    it 'should convert simple paragraph' do
      text = "ここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\n\n ここから、次のパラグラフです。"
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
      expect(r.shift.strip).to eq("<p class='noindent'>「二行目です。」</p>") 
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
