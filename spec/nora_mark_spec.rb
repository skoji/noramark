# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe NoraMark do 
  describe 'convert' do
    it 'should generate valid xhtml' do
      text = 'some text'
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      xhtml = Nokogiri::XML::Document.parse(noramark.html[0])
      expect(xhtml.root.name).to eq('html')
      expect(xhtml.root.namespaces['xmlns']).to eq('http://www.w3.org/1999/xhtml')
      expect(xhtml.root['xml:lang']).to eq('ja')
      expect(xhtml.root.element_children[0].name).to eq 'head'
      expect(xhtml.root.at_xpath('xmlns:head/xmlns:title').text).to eq('the title')
      expect(xhtml.root.element_children[1].name).to eq 'body'
    end
    it 'should convert simple paragraph' do
      text = "ここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\n\n ここから、次のパラグラフです。"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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
    it 'should convert simple paragraph in english mode' do
      text = "paragraph begins.\n2nd line.\n 3rd line.\n\n\n next paragraph."
      noramark = NoraMark::Document.parse(text, :lang => 'en', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 2
      expect(body.element_children[0].selector_and_children).to eq(
        ['p', 
         'paragraph begins.', ['br', ''],
         '2nd line.', ['br', ''],
         '3rd line.'
        ]
      )

      expect(body.element_children[1].selector_and_children).to eq(
        ['p', 'next paragraph.']
      )
    end

    it 'should convert simple paragraph in japanese mode, but paragraph mode is default' do
      text = "paragraph begins.\n2nd line.\n 3rd line.\n\n\n next paragraph."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title', :paragraph_style => :default)
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 2
      expect(body.element_children[0].selector_and_children).to eq(
        ['p', 
         'paragraph begins.', ['br', ''],
         '2nd line.', ['br', ''],
         '3rd line.'
        ]
      )

      expect(body.element_children[1].selector_and_children).to eq(
        ['p', 'next paragraph.']
      )
    end

    it 'should convert paragraph with header' do
      text = "h1: タイトルです。\r\nここから、パラグラフがはじまります。\n\nh2.column:ふたつめの見出しです。\n ここから、次のパラグラフです。\nh3.third.foo: クラスが複数ある見出しです"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the document title')
      converted = noramark.html
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
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
           ['p', '1st line.']
        ]
      )
    end

    it 'should nest div without pgroup' do
      text = "d(wo-pgroup) {\nd {\nnested.\n} \n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
          ['div',
           ['p', 'nested.']
         ]
        ]
      )
    end

    it 'should nest div without pgroup and with pgroup' do
      text = "d(wo-pgroup) {\nd {\nnested.\n} \n}\nd {\nin pgroup\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div',
          ['div',
           ['p', 'nested.']
         ]
        ])                                                                   
      expect(body.element_children[1].selector_and_children).to eq(
        ['div',
          ['div.pgroup',
           ['p', 'in pgroup']
         ]
        ])
    end


    it 'should convert div with class' do
      text = "d.preface-one {\n h1: title.\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.preface-one',
         ['h1', 'title.']
        ]
      )
    end

    it 'should convert div with id and class' do
      text = "d#thecontents.preface-one {\nh1: title.\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div#thecontents.preface-one',
         ['h1', 'title.']
        ]
      )
    end

    it 'should convert nested div' do
      text = "d.preface {\n outer div. \n d.nested {\n nested!\n}\nouter div again.\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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

    it 'should convert article' do
      text = "art {\n in the article.\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
     expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['div.pgroup',
        ['p', 'in the article.']
       ]
      ]
     ) 
    end

    it 'should convert article with other notation' do
      text = "arti {\n in the article.\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
     expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['div.pgroup',
        ['p', 'in the article.']
       ]
      ]
     ) 
    end

    it 'should convert article with yet anther notation' do
      text = "article {\n in the article.\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
     expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['div.pgroup',
        ['p', 'in the article.']
       ]
      ]
     ) 
    end

    it 'should convert section ' do
      text = "art {\nsec {\n section in the article. \n}\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['section',
       ['div.pgroup',
        ['p', 'section in the article.']
       ]
       ]
      ]
     ) 
    end

    it 'should convert section with other notation' do
      text = "art {\nsect {\n section in the article. \n}\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['section',
       ['div.pgroup',
        ['p', 'section in the article.']
       ]
       ]
      ]
     ) 
    end

    it 'should convert section with yet other notation' do
      text = "art {\nsection {\n section in the article. \n}\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['article',
       ['section',
       ['div.pgroup',
        ['p', 'section in the article.']
       ]
       ]
      ]
     ) 
    end



    it 'should handle block image' do
      text = "this is normal line.\nimage(./image1.jpg, alt text): caption text"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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

    it 'should handle block image with before caption' do
      text = "this is normal line.\nimage(./image1.jpg, alt text, caption_before: true): caption text"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
       ['div.pgroup',
        ['p', 'this is normal line.']
       ]
      )      
      expect(body.element_children[1].selector_and_children).to eq(
       ['div.img-wrap',
        ['p', 'caption text'],
        ["img[src='./image1.jpg'][alt='alt text']", '']
       ]
      )      
    end

    it 'should handle block image without caption' do
      text = "this is normal line.\nimage(./image1.jpg, alt text):"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
       ['div.pgroup',
        ['p', 'this is normal line.']
       ]
      )      
      expect(body.element_children[1].selector_and_children).to eq(
       ['div.img-wrap',
        ["img[src='./image1.jpg'][alt='alt text']", '']
       ]
      )      
    end
    
    it 'should handle page change article' do
      text = "this is start.\nnewpage(page changed):\nthis is second page.\nnewpage:\nand the third."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the document title', :stylesheets => ['reset.css', 'mystyle.css'])
      converted = noramark.html
      head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'the document title']
      expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='reset.css']", '']
      expect(head.element_children[2].a).to eq ["link[rel='stylesheet'][type='text/css'][href='mystyle.css']", '']
    end

    it 'should handle link' do
      text = " link to [link(http://github.com/skoji/noramark){noramark repository}]. \ncan you see this?"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
       ['p',
        'link to ',
         ["a[href='http://github.com/skoji/noramark']", 'noramark repository'],
         '.'
       ],
       ['p', 'can you see this?']
      ]
     )       
    end

    it 'should handle link with l' do
      text = "link to [l(http://github.com/skoji/noramark){noramark repository}]. \ncan you see this?"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
       ['p',
        'link to ',
         ["a[href='http://github.com/skoji/noramark']", 'noramark repository'],
         '.'
       ],
       ['p', 'can you see this?']
      ]
     )       
    end

    it 'should handle custom paragraph' do
      text = "this is normal line.\np.custom: this text is in custom class."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
         ['p.custom', 'this text is in ', ['span.keyword', 'custom'], ' class.'
        ]]
      )
    end

    it 'should handle any block' do
      text = "this is normal line.\ncite {\n this block should be in cite. \n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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
      text = "simple image [img(./image1.jpg, alt)]."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
          ['p',
            'simple image ', ["img[src='./image1.jpg'][alt='alt']", ''], '.']]
      )
    end

    it 'should handle any inline' do
      text = "should be [strong{marked as strong}]."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
      ['div.pgroup',
        ['p', 'should be ', ['strong', 'marked as strong'],'.']]
      )
    end

    it 'should convert inline command within line block' do
      text = "h1: [tcy{20}]縦中横タイトル"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq ['h1', ['span.tcy', '20'], '縦中横タイトル']
    end

    it 'should handle ruby' do
      text = "[ruby(とんぼ){蜻蛉}]の[ruby(めがね){眼鏡}]はみずいろめがね"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq ['div.pgroup', ['p', 
         ['ruby', '蜻蛉', ['rp','('],['rt','とんぼ'],['rp', ')']],
         'の',                                                                                   
         ['ruby', '眼鏡', ['rp','('],['rt','めがね'],['rp', ')']],
         'はみずいろめがね']]
    end

    it 'should handle tatechuyoko' do
      text = "[tcy{10}]年前のことだった"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', ['span.tcy', '10'], '年前のことだった']
        ])
    end

    it 'should handle ordered list ' do
      text = "this is normal line.\n1: for the 1st.\n2: secondly, blah.\n3: and last...\nthe ordered list ends."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 3
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'this is normal line.']
        ])
      expect(body.element_children[1].selector_and_children).to eq(
        ['ol', 
         ['li', 'for the 1st.'],
         ['li', 'secondly, blah.'],
         ['li', 'and last...']
        ])
      expect(body.element_children[2].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'the ordered list ends.']
        ])
    end

    it 'should handle unordered list ' do
      text = "this is normal line.\n*: for the 1st.\n*: secondly, blah.\n*: and last...\nthe ordered list ends."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 3
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'this is normal line.']
        ])
      expect(body.element_children[1].selector_and_children).to eq(
        ['ul', 
         ['li', 'for the 1st.'],
         ['li', 'secondly, blah.'],
         ['li', 'and last...']
        ])
      expect(body.element_children[2].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'the ordered list ends.']
        ])
    end

    it 'should handle definition list ' do
      text = "this is normal line.\n;: 1st : this is the first definition\n;: 2nd : blah :blah.\n;: 3rd: this term is the last.\nthe list ends."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children.size).to eq 3
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'this is normal line.']
        ])
      expect(body.element_children[1].selector_and_children).to eq(
        ['dl', 
         ['dt', '1st'],['dd', 'this is the first definition'],
         ['dt', '2nd'],['dd', 'blah :blah.'],
         ['dt', '3rd'],['dd', 'this term is the last.'],
        ])
      expect(body.element_children[2].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'the list ends.']
        ])
    end

    it 'should escape html' do
      text = ";:definition<div>:</div>&"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['dl', 
         ['dt', 'definition<div>'],['dd', '</div>&']
        ])
    end

    it 'should specify stylesheets' do
      text = "stylesheets:css/default.css, css/specific.css, css/iphone.css:(only screen and (min-device-width : 320px) and (max-device-width : 480px))\n\ntext."
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the document title')
      converted = noramark.html
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
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'the title of the book in the text.']
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
          ['p',
            'text.']])

    end

    it 'should specify title on each page' do
      text = "title:page1\n\n1st page.\nnewpage:\ntitle:page2\nh1:2nd page"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title', :paragraph_style => :use_paragraph_group)
      converted = noramark.html
      # 1st page
      head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'page1']
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup',
          ['p',
            '1st page.']])
      # 2nd page
      head = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:head')
      expect(head.element_children[0].a).to eq ['title', 'page2']
      body = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['h1',"2nd page"])
    end


    it 'should ignore comments' do
      text = "# この行はコメントです\nここから、パラグラフがはじまります。\n # これもコメント\n「二行目です。」\n三行目です。\n\n# これもコメント\n\n ここから、次のパラグラフです。"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
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

    it 'should handle preprocessor' do
      text = "pre-preprocess text"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title') do
        |nora|
        nora.preprocessor do
          |text|
          text.gsub('pre-preprocess', 'post-process')
        end
      end
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(
        ['div.pgroup', 
         ['p', 'post-process text'],
        ]
      )
    end

    it 'should convert h1 in article after title' do
      text = "stylesheets: css/default.css\ntitle: foo\narticle.atogaki {\n\nh1: あとがき。\n\natogaki\n}"
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
     expect(body.element_children[0].selector_and_children).to eq(
["article.atogaki",
 ["h1", "あとがき。"],
 ["div.pgroup",
  ["p", "atogaki"]]]
     ) 
    end

    it 'should convert preformatted text' do
      text = <<EOF
normal line.
pre <<END
d {
   this will not converted to div or p or pgroup.
line_command: this will be not converted too.
}
END
EOF
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(["div.pgroup", ["p", "normal line."]])
      expect(body.element_children[1].selector_and_children).to eq(["pre", "d {\n   this will not converted to div or p or pgroup.\nline_command: this will be not converted too.\n}"])
    end
    it 'should convert preformatted code' do
      text = <<EOF
normal line.
precode <<END
d {
   this will not converted to div or p or pgroup.
line_command: this will be not converted too.
}
END
normal line again.
EOF
      noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
      converted = noramark.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children).to eq(["div.pgroup", ["p", "normal line."]])
      expect(body.element_children[1].selector_and_children).to eq(["pre", ["code", "d {\n   this will not converted to div or p or pgroup.\nline_command: this will be not converted too.\n}"]])
      expect(body.element_children[2].selector_and_children).to eq(["div.pgroup", ["p", "normal line again."]])
    end

    it 'should raise error' do
      text = "d {\n block is\nd {\n nested but\nd {\n not terminated }"
      expect { NoraMark::Document.parse(text, :lang => 'ja', :title => 'foo') }.to raise_error KPeg::CompiledParser::ParseError
    end

    describe 'markdown style' do
      it 'should convert markdown style heading' do
        text = "=: タイトルです。\r\nこれは、セクションの中です。"
        noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 1
        expect(body.element_children[0].selector_and_children).to eq(
        ['section',
          ['h1', 'タイトルです。'],
          ['div.pgroup', 
           ['p', 'これは、セクションの中です。']]]
      )
      end
      it 'should markdown style heading interrupted by other headed section' do
        text = "=: タイトルです。\r\nこれは、セクションの中です。\n =: また次のセクションです。\n次のセクションの中です。"
        noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children).to eq(
        ['section',
          ['h1', 'タイトルです。'],
          ['div.pgroup', 
           ['p', 'これは、セクションの中です。']]])
        expect(body.element_children[1].selector_and_children).to eq(
        ['section',
          ['h1', 'また次のセクションです。'],
          ['div.pgroup', 
           ['p', '次のセクションの中です。']]]
      )
      end
      it 'should markdown style heading not interrupted by other explicit section' do
        text = "=: タイトルです。\r\nこれは、セクションの中です。\n section {\n h2: また次のセクションです。\n入れ子になります。\n}\nこのように。"
        noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 1
        expect(body.element_children[0].selector_and_children).to eq(
        ['section',
          ['h1', 'タイトルです。'],
          ['div.pgroup', 
           ['p', 'これは、セクションの中です。']],
           ['section',
             ['h2', 'また次のセクションです。'],
             ['div.pgroup', 
              ['p', '入れ子になります。']]],
          ['div.pgroup', 
           ['p', 'このように。']]]
      )
      end
      it 'should markdown style heading not interrupted by smaller section' do
        text = "=: タイトルです。\r\nこれは、セクションの中です。\n ==: また次のセクションです。\n 入れ子になります。\n===: さらに中のセクション \nさらに入れ子になっているはず。\n=:ここで次のセクションです。\n脱出しているはずです。"
        noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children).to eq(
        ['section',
          ['h1', 'タイトルです。'],
          ['div.pgroup', 
           ['p', 'これは、セクションの中です。']],
           ['section',
             ['h2', 'また次のセクションです。'],
             ['div.pgroup', 
              ['p', '入れ子になります。']],
            ['section',
             ['h3', 'さらに中のセクション'],
             ['div.pgroup', 
              ['p', 'さらに入れ子になっているはず。']]]]] )
        expect(body.element_children[1].selector_and_children).to eq(
        ['section',
          ['h1', 'ここで次のセクションです。'],
          ['div.pgroup', 
           ['p', '脱出しているはずです。']]])

      end
    end
    describe 'create file' do
      before { @basedir = File.join(File.dirname(__FILE__), 'created_files') }
      after { Dir.glob(File.join(@basedir, '*.xhtml')) { |file| File.delete file } }
      it 'should create default file' do
        text = "some text"
        noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the title')
        noramark.html.write_as_files(directory: @basedir)
        expect(File.basename(Dir.glob(File.join(@basedir, '*.xhtml'))[0])).to match /noramark_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}_00001.xhtml/
      end
      it 'should create named file' do
        text = "some text\nnewpage:\nnext page"
        noramark = NoraMark::Document.parse(text, :lang => 'ja', :title => 'the document title', filename_base: 'nora-test-file', sequence_format: '%03d' )
        noramark.html.write_as_files(directory: @basedir)
        files = Dir.glob(File.join(@basedir, '*.xhtml'))
        expect(File.basename(files[0])).to eq 'nora-test-file_001.xhtml'
        expect(File.basename(files[1])).to eq 'nora-test-file_002.xhtml'
      end
    end
  end
end