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
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 2

      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'ここから、パラグラフがはじまります。'],
         ['p.noindent', '「二行目です。」'],
         ['p', '三行目です。']
        ]
      )

      expect(body.element_children[1].selector_and_children).to eq(
        ['div.pgroup',
          ['p', 'ここから、次のパラグラフです。']]
      )
    end
    it 'should convert paragraph with header' do
      text = "h1: タイトルです。\r\nここから、パラグラフがはじまります。\n\nh2.column:ふたつめの見出しです。\n ここから、次のパラグラフです。\nh3.third.foo: クラスが複数ある見出しです"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 5
      expect(body.element_children[0].a).to eq ['h1', 'タイトルです。']
      expect(body.element_children[1].selector_and_children).to eq(
        ['div.pgroup',
          ['p', 'ここから、パラグラフがはじまります。']
        ]
      )
      expect(body.element_children[2].a).to eq ['h2.column', 'ふたつめの見出しです。']
      expect(body.element_children[3].selector_and_children).to eq(
        ['div.pgroup',
         ['p', 'ここから、次のパラグラフです。']
        ]
      )
      expect(body.element_children[4].a).to eq ['h3.third.foo', 'クラスが複数ある見出しです']
    end

    it 'should convert div and paragraph' do
      text = "d {\n1st line. \n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
          ['div.pgroup',
           ['p', '1st line.']
          ]
        ]
      )
    end

    it 'should convert div and paragraph with alternate style' do
      text = "d {---\n1st line. \n---}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
          ['div.pgroup',
           ['p', '1st line.']
          ]
        ]
      )
    end
    it 'should convert div without pgroup' do
      text = "d(wo-pgroup) {\n1st line. \n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
           ['p', '1st line.']
        ]
      )
    end

    it 'should nest div without pgroup' do
      text = "d(wo-pgroup) {\nd {\nnested.\n} \n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
          ['div',
           ['p', 'nested.']
         ]
        ]
      )
    end

    it 'should convert div with class' do
      text = "d.preface-one {\n h1: title.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.preface-one',
         ['h1', 'title.']
        ]
      )
    end

    it 'should convert nested div' do
      text = "d.preface {\n outer div. \n d.nested {\n nested!\n}\nouter div again.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.preface',
         ['div.pgroup',
          ['p', 'outer div.']
         ],
         ['div.nested',
          ['div.pgroup',
           ['p', 'nested!']
          ]
         ],
         ['div.pgroup',
          ['p', 'outer div again.']
         ],
        ]
      )
    end
    
    it 'should convert nested div with alternate style inside' do
      text = "d.preface {\n outer div. \n d.nested {---\n nested!\n---}\nouter div again.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.preface',
         ['div.pgroup',
          ['p', 'outer div.']
         ],
         ['div.nested',
          ['div.pgroup',
           ['p', 'nested!']
          ]
         ],
         ['div.pgroup',
          ['p', 'outer div again.']
         ],
        ]
      )
    end

   it 'should convert nested div with alternate style outside' do
      text = "d.preface {---\n outer div. \n}\nyou can write curly brace as above.\nd.nested {\n nested!\n}\nouter div again.\n---}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.preface',
         ['div.pgroup',
          ['p', 'outer div.'],
          ['p', '}'],
          ['p', 'you can write curly brace as above.']
         ],
         ['div.nested',
          ['div.pgroup',
           ['p', 'nested!']
          ]
         ],
         ['div.pgroup',
          ['p', 'outer div again.']
         ],
        ]
      )
    end    
    it 'should convert article' do
      text = "art {\n in the article.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
     expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['div.pgroup',
        ['p', 'in the article.']
       ]
      ]
     ) 
    end

    it 'should handle block image' do
      text = "this is normal line.\nimage(./image1.jpg, alt text): caption text"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
       ['div.pgroup',
        ['p', 'this is normal line.']
       ]
      )      
      expect(body.element_children[1].selector_and_children).to eq(
       ['div.img-wrap',
        ["img[src='./image1.jpg'][alt='alt text']", ''],
        ['p', 'caption text']
       ]
      )      
    end

    it 'should handle page change article' do
      text = "this is start.\nnewpage(page changed):\nthis is second page.\nnewpage:\nand the third."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      expect(converted.size).to eq 3
      body1 = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body1.element_children[0].selector_and_children).to eq(
       ['div.pgroup',
        ['p', 'this is start.']
       ]
      )

      head2 = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:head')
      expect(head2.element_children[0].a).to eq ['title', 'page changed']
      body2 = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:body')
      expect(body2.element_children[0].selector_and_children).to eq(
       ['div.pgroup',
        ['p', 'this is second page.']
       ]
      )

      head3 = Nokogiri::XML::Document.parse(converted[2]).root.at_xpath('xmlns:head')
      expect(head3.element_children[0].a).to eq ['title', 'page changed']
      body3 = Nokogiri::XML::Document.parse(converted[2]).root.at_xpath('xmlns:body')
      expect(body3.element_children[0].selector_and_children).to eq(
       ['div.pgroup',
        ['p', 'and the third.']
       ]
      )
    end

    it 'should handle stylesheets' do
      text = "d.styled {\n this is styled document.\n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title', :stylesheets => ['reset.css', 'mystyle.css'])
      converted = artimark.convert(text)
      head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'the document title']
      expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='reset.css']", '']
      expect(head.element_children[2].a).to eq ["link[rel='stylesheet'][type='text/css'][href='mystyle.css']", '']
    end

    it 'should handle link' do
      text = "link to [link(http://github.com/skoji/artimark){artimark repository}]. \ncan you see this?"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
       ['p',
        'link to ',
         ["a[href='http://github.com/skoji/artimark']", 'artimark repository'],
         '.'
       ],
       ['p', 'can you see this?']
      ]
     )       
    end
    it 'should handle link with l' do
      text = "link to [l(http://github.com/skoji/artimark){artimark repository}]. \ncan you see this?"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
       ['p',
        'link to ',
         ["a[href='http://github.com/skoji/artimark']", 'artimark repository'],
         '.'
       ],
       ['p', 'can you see this?']
      ]
     )       
    end
    it 'should handle custom paragraph' do
      text = "this is normal line.\np.custom: this text is in custom class."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
       ['p', 'this is normal line.'],
       ['p.custom', 'this text is in custom class.']
      ]
     )        
    end
    it 'should handle span' do
      text = "p.custom: this text is in [s.keyword{custom}] class."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
         ['p.custom', 'this text is in ', ['span.keyword', 'custom'], ' class.'
        ]]
      )
    end
    it 'should handle any block' do
      text = "this is normal line.\ncite {\n this block should be in cite. \n}"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
          ['p', 'this is normal line.']
        ]
      )
      expect(body.element_children[1].selector_and_children).to eq(
        ['cite',
         ['div.pgroup',
            ['p', 'this block should be in cite.']
          ]
        ]
      )
    end
    it 'should handle inline image' do
      text = "simple image [img(caption){./image1.jpg}]."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
          ['p',
            'simple image ', ["img[src='./image1.jpg'][alt='caption']", ''], '.']]
      )
    end

    it 'should handle any inline' do
      text = "should be [strong{marked as strong}]."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
        ['p', 'should be ', ['strong', 'marked as strong'],'.']]
      )
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
      text = "[ruby(とんぼ){蜻蛉}]の[ruby(めがね){眼鏡}]はみずいろめがね"
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
      text = "stylesheets:css/default.css, css/specific.css, css/iphone.css:(only screen and (min-device-width : 320px) and (max-device-width : 480px))\n\ntext."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'the document title']
      expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='css/default.css']", '']
      expect(head.element_children[2].a).to eq ["link[rel='stylesheet'][type='text/css'][href='css/specific.css']", '']
      expect(head.element_children[3].a).to eq ["link[rel='stylesheet'][type='text/css'][media='only screen and (min-device-width : 320px) and (max-device-width : 480px)'][href='css/iphone.css']", '']

      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
          ['p',
            'text.']])
    end

    it 'should specify title' do
      text = "title:the title of the book in the text.\n\ntext."
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'the title of the book in the text.']
    end

    it 'should specify lang' do
      text = "lang:ja\n\n日本語 text."
      artimark = ArtiMark::Document.new(:lang => 'en', :title => 'the document title')
      converted = artimark.convert(text)
      root = Nokogiri::XML::Document.parse(converted[0]).root
      expect(root['lang']).to eq 'ja'
    end

    it 'should ignore comments' do
      text = "#この行はコメントです\nここから、パラグラフがはじまります。\n#これもコメント\n「二行目です。」\n三行目です。\n\n#これもコメント\n\n ここから、次のパラグラフです。"
      artimark = ArtiMark::Document.new(:lang => 'ja', :title => 'the document title')
      converted = artimark.convert(text)
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 2

      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'ここから、パラグラフがはじまります。'],
         ['p.noindent', '「二行目です。」'],
         ['p', '三行目です。']
        ]
      )

      expect(body.element_children[1].selector_and_children).to eq(
        ['div.pgroup',
          ['p', 'ここから、次のパラグラフです。']]
      )
    end
  end
end

