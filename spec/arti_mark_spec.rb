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
    it 'should convert paragraph with header' do
      text = "h1: タイトルです。\nここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\nh2.column:ふたつめの見出しです。\n ここから、次のパラグラフです。\nh3.third.foo: クラスが複数ある見出しです"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq("<h1>タイトルです。</h1>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>ここから、パラグラフがはじまります。</p>") 
      expect(r.shift.strip).to eq("<p class='noindent'>「二行目です。」</p>") 
      expect(r.shift.strip).to eq("<p>三行目です。</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<h2 class='column'>ふたつめの見出しです。</h2>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>ここから、次のパラグラフです。</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<h3 class='third foo'>クラスが複数ある見出しです</h3>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>") 
    end

    it 'should convert div and paragraph' do
      text = "d {\n h1: title. \n 1st line. \n「二行目」\n\n new paragraph in div.\n}\n here comes new paragraph."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq('<div>')   
      expect(r.shift.strip).to eq("<h1>title.</h1>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>1st line.</p>") 
      expect(r.shift.strip).to eq("<p class='noindent'>「二行目」</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>new paragraph in div.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>here comes new paragraph.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>") 
    end

    it 'should convert div with class' do
      text = "d.preface {\n h1: title. \n 1st line. \n「二行目」\n\n new paragraph in div.\n}\n here comes new paragraph."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq('<div class=\'preface\'>')   
      expect(r.shift.strip).to eq("<h1>title.</h1>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>1st line.</p>") 
      expect(r.shift.strip).to eq("<p class='noindent'>「二行目」</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>new paragraph in div.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>here comes new paragraph.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>") 
    end
    it 'should convert nested div' do
      text = "d.preface {\n h1: title. \n 1st line. \n「二行目」\n\n new paragraph in div.\n d.nested {\n nested!\n}\n}\n here comes new paragraph."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq('<div class=\'preface\'>')   
      expect(r.shift.strip).to eq("<h1>title.</h1>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>1st line.</p>") 
      expect(r.shift.strip).to eq("<p class='noindent'>「二行目」</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>new paragraph in div.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='nested'>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>nested!</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>here comes new paragraph.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>") 
    end
    it 'should convert article' do
      text = "art {\nd.preface {\n h1: title. \n 1st line. \n「二行目」\n\n new paragraph in div.\n d.nested {\n nested!\n}\n}\n here comes new paragraph.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq('<article>')   
      expect(r.shift.strip).to eq('<div class=\'preface\'>')   
      expect(r.shift.strip).to eq("<h1>title.</h1>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>1st line.</p>") 
      expect(r.shift.strip).to eq("<p class='noindent'>「二行目」</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>new paragraph in div.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='nested'>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>nested!</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>here comes new paragraph.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq('</article>')   
     expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>") 
    end

    it 'should handle page change article' do
      text = "this is start.\nnewpage,page changed:\nthis is second page.\nnewpage:\nand the third."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      expect(converted.size).to eq 3
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq('<p>this is start.</p>')   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")

      r = converted[1].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>page changed</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq('<p>this is second page.</p>')   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")

      r = converted[2].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>page changed</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq('<p>and the third.</p>')   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
     end
    it 'should handle stylesheets' do
      text = "d.styled {\n this is styled document.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title', :stylesheets => ['reset.css', 'mystyle.css'])
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq("<link rel=\"stylesheet\" type=\"text/css\" href=\"reset.css\" />")
      expect(r.shift.strip).to eq("<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyle.css\" />")
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>')   
      expect(r.shift.strip).to eq("<div class='styled'>") 
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq('<p>this is styled document.</p>')   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
  end
end
