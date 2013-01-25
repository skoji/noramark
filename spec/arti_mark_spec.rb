# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/arti_mark'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe ArtiMark do 
  describe 'convert' do
      it 'should generate valid xhtml' do
            text = 'some text'
            artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the title')
            xhtml = Nokogiri::XML::Document.parse(artimark.convert(text)[0])
            expect(xhtml.root.name).to eq('html')
            expect(xhtml.root.namespaces['xmlns']).to eq('http://www.w3.org/1999/xhtml')
            expect(xhtml.root['xml:lang']).to eq('ja')
            expect(xhtml.root.element_children[0].name).to eq 'head'
            expect(xhtml.root.at_xpath('xmlns:head/xmlns:title').text).to eq('the title')
            expect(xhtml.root.element_children[1].name).to eq 'body'
      end
      it 'should convert simple paragraph' do
            text = "ここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\n\n ここから、次のパラグラフです。"
            artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
            body = Nokogiri::XML::Document.parse(artimark.convert(text)[0]).root.at_xpath('xmlns:body')
            expect(body.element_children.size).to eq 2

            first_paragraph = body.element_children[0]
            expect(first_paragraph.selector_str).to eq 'div.pgroup'
            expect(first_paragraph.element_children.size).to eq 3
            expect(first_paragraph.element_children[0].selector_and_text).to eq ['p', 'ここから、パラグラフがはじまります。']
            expect(first_paragraph.element_children[1].selector_and_text).to eq ['p.noindent', '「二行目です。」']
            expect(first_paragraph.element_children[2].selector_and_text).to eq ['p', '三行目です。']
            second_paragraph = body.element_children[1]
            expect(second_paragraph.selector_str).to eq 'div.pgroup'
            expect(second_paragraph.element_children.size).to eq 1
            expect(second_paragraph.element_children[0].selector_and_text).to eq ['p', 'ここから、次のパラグラフです。'] 

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
    it 'should handle block image' do
      text = "this is normal line.\nimage(./image1.jpg, alt text): caption text"
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<div class='img-wrap'><img src='./image1.jpg' alt='alt text' /><p>caption text</p></div>")
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end

    it 'should handle page change article' do
      text = "this is start.\nnewpage(page changed):\nthis is second page.\nnewpage:\nand the third."
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
    it 'should handle link' do
      text = "link to :l(http://github.com/skoji/artimark){artimark repository}:. \ncan you see this?"
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
      expect(r.shift.strip).to eq("<p>link to <a href='http://github.com/skoji/artimark'>artimark repository</a>.</p>")   
      expect(r.shift.strip).to eq("<p>can you see this?</p>")   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should handle custom paragraph' do
      text = "this is normal line.\np.custom: this text is in custom class."
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>")   
      expect(r.shift.strip).to eq("<p class='custom'>this text is in custom class.</p>")   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should handle span' do
      text = "this is normal line.\np.custom: this text is in :s.keyword{custom}: class."
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>")   
      expect(r.shift.strip).to eq("<p class='custom'>this text is in <span class='keyword'>custom</a> class.</p>")   
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should handle any block' do
      text = "this is normal line.\ncite {\n this block should be in cite. \n}"
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("</div>")
      expect(r.shift.strip).to eq("<cite>")
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>this block should be in cite.</p>")
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</cite>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should handle inline image' do
      text = "this is normal line.\nsimple image :img(caption){./image1.jpg}:"
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("<p>simple image <img src='./image1.jpg' alt='caption' /></p>")
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end

    it 'should handle any inline' do
      text = "this is normal line.\nin this line, this should be :strong{marked as strong}:."
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("<p>in this line, this should be <strong>marked as strong</strong>.</p>")
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should generate toc: with newpage parameter' do
      text = "newpage(1st chapter):\n1st chapter.\nnewpage(2nd chapter):\n2nd chapger.\nnewpage: 2nd chapter continued.\nnewpage(3rd chapter):\n3rd chapter."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      artimark.convert(text)
      toc = artimark.toc
      expect(toc[0]).to eq('1st chapter')
      expect(toc[1]).to eq('2nd chapter')
      expect(toc[2]).to be_nil
      expect(toc[3]).to eq('3rd chapter')
    end

    it 'should generate toc with h parameter' do
      text = "newpage:\nh1(in-toc): 1st chapter\n content.\nnewpage:\nh1(in-toc): 2nd chapter\ncontent.\nnewpage: 2nd chapter continued.\nnewpage:\nh1(in-toc): 3rd chapter\n content."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      artimark.convert(text)
      toc = artimark.toc
      expect(toc[0]).to eq('1st chapter')
      expect(toc[1]).to eq('2nd chapter')
      expect(toc[2]).to be_nil
      expect(toc[3]).to eq('3rd chapter')
    end

    it 'should handle ruby' do
      text = ":ruby(とんぼ){蜻蛉}:の:ruby(めがね){眼鏡}:はみずいろめがね"
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
      expect(r.shift.strip).to eq("<p><ruby>蜻蛉<rp>(</rp><rt>とんぼ</rt><rp>)</rp></ruby>の<ruby>眼鏡<rp>(</rp><rt>めがね</rt><rp>)</rp></ruby>はみずいろめがね</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end


    it 'should handle ordered list ' do
      text = "this is normal line.\n1: for the 1st.\n2: secondly, blah.\n3: and last...\nthe ordered list ends."
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<ol>")
      expect(r.shift.strip).to eq("<li>for the 1st.</li>")
      expect(r.shift.strip).to eq("<li>secondly, blah.</li>")
      expect(r.shift.strip).to eq("<li>and last...</li>")
      expect(r.shift.strip).to eq("</ol>")
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>the ordered list ends.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should handle unordered list ' do
      text = "this is normal line.\n*: for the 1st.\n*: secondly, blah.\n*: and last...\nthe ordered list ends."
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<ul>")
      expect(r.shift.strip).to eq("<li>for the 1st.</li>")
      expect(r.shift.strip).to eq("<li>secondly, blah.</li>")
      expect(r.shift.strip).to eq("<li>and last...</li>")
      expect(r.shift.strip).to eq("</ul>")
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>the ordered list ends.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end
    it 'should handle definition list ' do
      text = "this is normal line.\n;: 1st : this is the first definition\n;: 2nd : blah :blah.\n;: 3rd: this term is the last.\nthe list ends."
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
      expect(r.shift.strip).to eq("<p>this is normal line.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("<dl>")
      expect(r.shift.strip).to eq("<dt>1st</dt><dd>this is the first definition</dd>")
      expect(r.shift.strip).to eq("<dt>2nd</dt><dd>blah :blah.</dd>")
      expect(r.shift.strip).to eq("<dt>3rd</dt><dd>this term is the last.</dd>")
      expect(r.shift.strip).to eq("</dl>")
      expect(r.shift.strip).to eq("<div class='pgroup'>") 
      expect(r.shift.strip).to eq("<p>the list ends.</p>") 
      expect(r.shift.strip).to eq("</div>") 
      expect(r.shift.strip).to eq("</body>") 
      expect(r.shift.strip).to eq("</html>")
    end

    it 'should escape html' do
      text = ";:definition<>:<>&"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>') 
      expect(r.shift.strip).to eq('<dl>')        
      expect(r.shift.strip).to eq('<dt>definition&lt;&gt;</dt><dd>&lt;&gt;&amp;</dd>')        
    end
    it 'should specify stylesheets' do
      text = "stylesheets:css/default.css, css/specific.css, css/iphone.css:(only screen and (min-device-width : 320px) and (max-device-width : 480px))\ntext."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      r = converted[0].rstrip.split(/\r?\n/).map { |line| line.chomp }
      expect(r.shift.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
      expect(r.shift.strip).to eq('<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">')
      expect(r.shift.strip).to eq('<head>')   
      expect(r.shift.strip).to eq('<title>the document title</title>')
      expect(r.shift.strip).to eq('<link rel="stylesheet" type="text/css" href="css/default.css" />')
      expect(r.shift.strip).to eq('<link rel="stylesheet" type="text/css" href="css/specific.css" />')
      expect(r.shift.strip).to eq('<link rel="stylesheet" type="text/css" media="only screen and (min-device-width : 320px) and (max-device-width : 480px)" href="css/iphone.css" />')
      expect(r.shift.strip).to eq('</head>')   
      expect(r.shift.strip).to eq('<body>') 
    end
  end
end

