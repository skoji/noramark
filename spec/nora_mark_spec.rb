# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe NoraMark::Document do 
  describe 'parse' do
    it 'generate valid xhtml' do
      text = 'some text'
      noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
      xhtml = Nokogiri::XML::Document.parse(noramark.html[0])
      expect(xhtml.root.name).to eq('html')
      expect(xhtml.root.namespaces['xmlns'])
        .to eq('http://www.w3.org/1999/xhtml')
      expect(xhtml.root['xml:lang'])
        .to eq('ja')
      expect(xhtml.root.element_children[0].name).to eq 'head'
      expect(xhtml.root.at_xpath('xmlns:head/xmlns:title').text)
        .to eq('the title')
      expect(xhtml.root.element_children[1].name).to eq 'body'
    end
    describe 'implicit markup' do
      it 'convert simple paragraph' do
        text = "ここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\n\n ここから、次のパラグラフです。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'ここから、パラグラフがはじまります。'],
                  ['p.noindent', '「二行目です。」'],
                  ['p', '三行目です。']
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'ここから、次のパラグラフです。']]
                 )
      end
      it 'convert simple paragraph with BOM' do
        text = "\uFEFFここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\n\n ここから、次のパラグラフです。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'ここから、パラグラフがはじまります。'],
                  ['p.noindent', '「二行目です。」'],
                  ['p', '三行目です。']
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'ここから、次のパラグラフです。']]
                 )
      end

      it 'convert simple paragraph in english mode' do
        text = "paragraph begins.\n2nd line.\n 3rd line.\n\n\n next paragraph."
        noramark = NoraMark::Document.parse(text, lang: 'en', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['p', 
                  'paragraph begins.', ['br', ''],
                  '2nd line.', ['br', ''],
                  '3rd line.'
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['p', 'next paragraph.']
                 )
      end


      it 'convert simple paragraph in english mode specified in frontmatter' do
        text = "---\nlang: en\ntitle: the title\n---\n\n\n\nparagraph begins.\n2nd line.\n 3rd line.\n\n\n next paragraph."
        noramark = NoraMark::Document.parse(text)
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['p', 
                  'paragraph begins.', ['br', ''],
                  '2nd line.', ['br', ''],
                  '3rd line.'
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['p', 'next paragraph.']
                 )
      end

      it 'convert simple paragraph in japanese mode, but paragraph mode is default' do
        text = "paragraph begins.\n2nd line.\n 3rd line.\n\n\n next paragraph."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title', paragraph_style: :default)
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['p', 
                  'paragraph begins.', ['br', ''],
                  '2nd line.', ['br', ''],
                  '3rd line.'
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['p', 'next paragraph.']
                 )
      end

      it 'convert simple paragraph in japanese mode, but paragraph mode is default (using frontmatter)' do
        text = "---\nlang: ja\ntitle: the title\nparagraph_style: default\n---\nparagraph begins.\n2nd line.\n 3rd line.\n\n\n next paragraph."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title', paragraph_styl: :default)
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['p', 
                  'paragraph begins.', ['br', ''],
                  '2nd line.', ['br', ''],
                  '3rd line.'
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['p', 'next paragraph.']
                 )
      end
    end
    describe 'attribute handling' do
      it 'accept data- named parameter as attributes' do
        noramark = NoraMark::Document.parse('[span[data-type:foobar]{lorem ipsum}]')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                  ['p',
                   ["span[data-type='foobar']", 'lorem ipsum']]
                 )
      end
    end
    describe 'divs and hN headers' do
      it 'parse paragraph with header' do
        text = "h1: タイトルです。\r\nここから、パラグラフがはじまります。\n\nh2.column:ふたつめの見出しです。\n ここから、次のパラグラフです。\nh3.third.foo: クラスが複数ある見出しです"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 5
        expect(body.element_children[0].a).to eq ['h1', 'タイトルです。']
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'ここから、パラグラフがはじまります。']
                 ]
                 )
        expect(body.element_children[2].a).to eq ['h2.column', 'ふたつめの見出しです。']
        expect(body.element_children[3].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'ここから、次のパラグラフです。']
                 ]
                 )
        expect(body.element_children[4].a).to eq ['h3.third.foo', 'クラスが複数ある見出しです']
      end

      it 'parse div and paragraph' do
        text = "d {\n1st line. \n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the document title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div',
                  ['div.pgroup',
                   ['p', '1st line.']
                  ]
                 ]
                 )
      end


      it 'parse div without pgroup' do
        text = "d('wo-pgroup') {\n1st line. \n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div',
                  ['p', '1st line.']
                 ]
                 )
      end

      it 'parse nested div without pgroup' do
        text = "d(wo-pgroup) {\nd {\nnested.\n} \n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div',
                  ['div',
                   ['p', 'nested.']
                  ]
                 ]
                 )
      end

      it 'handle divs with empty lines' do
        text = "\n\n\nd('wo-pgroup') {\n\n\n1st line. \n\n\n}\n\n\nd {\n 2nd div.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div',
                  ['p', '1st line.']
                 ])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['div',
                  ['div.pgroup',
                   ['p', '2nd div.']]
                 ]

                 )
      end

      it 'parse nested div without pgroup and with pgroup' do
        text = "d(wo-pgroup) {\nd {\nnested.\n} \n}\n\nd {\nin pgroup\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div',
                  ['div',
                   ['p', 'nested.']
                  ]
                 ])                                                                   
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['div',
                  ['div.pgroup',
                   ['p', 'in pgroup']
                  ]
                 ])
      end

      it 'parse div with class' do
        text = "d.preface-one {\n h1: title.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.preface-one',
                  ['h1', 'title.']
                 ]
                 )
      end

      it 'parse div with id and class' do
        text = "d#thecontents.preface-one {\nh1: title.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children(remove_id: false))
          .to eq(
                 ['div#thecontents.preface-one',
                  ['h1#heading_index_1', 'title.']
                 ]
                 )
      end

      it 'parse nested div' do
        text = "d.preface {\n outer div. \n d.nested {\n nested!\n}\nouter div again.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
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
    end
    describe 'article and section' do
      it 'parse article' do
        text = "art {\n in the article.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['article',
                  ['div.pgroup',
                   ['p', 'in the article.']
                  ]
                 ]
                 ) 
      end

      it 'parse article with other notation' do
        text = "arti {\n in the article.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['article',
                  ['div.pgroup',
                   ['p', 'in the article.']
                  ]
                 ]
                 ) 
      end

      it 'parse article with yet anther notation' do
        text = "article {\n in the article.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['article',
                  ['div.pgroup',
                   ['p', 'in the article.']
                  ]
                 ]
                 ) 
      end

      it 'parse section ' do
        text = "art {\nsec {\n section in the article. \n}\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['article',
                  ['section',
                   ['div.pgroup',
                    ['p', 'section in the article.']
                   ]
                  ]
                 ]
                 ) 
      end

      it 'parse section with other notation' do
        text = "art {\nsect {\n section in the article. \n}\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['article',
                  ['section',
                   ['div.pgroup',
                    ['p', 'section in the article.']
                   ]
                  ]
                 ]
                 ) 
      end

      it 'parse section with yet other notation' do
        text = "art {\nsection {\n section in the article. \n}\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['article',
                  ['section',
                   ['div.pgroup',
                    ['p', 'section in the article.']
                   ]
                  ]
                 ]
                 ) 
      end
    end
    describe 'other block command' do
      it 'handle block image' do
        text = "this is normal line.\nimage(./image1.jpg, \"alt text\"): caption text"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is normal line.']
                 ]
                 )      
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['figure.img-wrap',
                  ["img[src='./image1.jpg'][alt='alt text']", ''],
                  ['figcaption', 'caption text']
                 ]
                 )      
      end

      it 'handle block image with before caption' do
        text = "this is normal line.\nimage(./image1.jpg, alt text)[caption_before: 'true']: caption text"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is normal line.']
                 ]
                 )      
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['figure.img-wrap',
                  ['figcaption', 'caption text'],
                  ["img[src='./image1.jpg'][alt='alt text']", '']
                 ]
                 )      
      end

      it 'handle block image without caption' do
        text = "this is normal line.\nimage(./image1.jpg, alt text):"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is normal line.']
                 ]
                 )      
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['figure.img-wrap',
                  ["img[src='./image1.jpg'][alt='alt text']", '']
                 ]
                 )      
      end

      it 'handle page change article' do
        text = "this is start.\nnewpage:\n---\ntitle: page changed\n---\n\nthis is second page.\nnewpage:\nand the third."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        expect(converted.size).to eq 3

        body1 = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body1.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is start.']
                 ]
                 )

        head2 = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:head')
        expect(head2.element_children[0].a).to eq ['title', 'page changed']
        body2 = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:body')
        expect(body2.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is second page.']
                 ]
                 )

        head3 = Nokogiri::XML::Document.parse(converted[2]).root.at_xpath('xmlns:head')
        expect(head3.element_children[0].a).to eq ['title', 'the title'] 
        body3 = Nokogiri::XML::Document.parse(converted[2]).root.at_xpath('xmlns:body')
        expect(body3.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'and the third.']
                 ]
                 )
      end

      it 'handle stylesheets' do
        text = "d.styled {\n this is styled document.\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the document title', stylesheets: ['reset.css', 'mystyle.css'])
        converted = noramark.html
        head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'the document title']
        expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='reset.css']", '']
        expect(head.element_children[2].a).to eq ["link[rel='stylesheet'][type='text/css'][href='mystyle.css']", '']
      end

      it 'handle custom paragraph' do
        text = "this is normal line.\np.custom: this text is in custom class."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is normal line.'],
                  ['p.custom', 'this text is in custom class.']
                 ]
                 )        
      end

      it 'handle any block' do
        text = "this is normal line.\ncite {\n this block should be in cite. \n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'this is normal line.']
                 ]
                 )
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['cite',
                  ['div.pgroup',
                   ['p', 'this block should be in cite.']
                  ]
                 ]
                 )
      end
      it 'convert h1 in article after title' do
        text = "---\nstylesheets: css/default.css\ntitle: foo\n---\narticle.atogaki {\n\nh1: あとがき。\n\natogaki\n}"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ["article.atogaki",
                  ["h1", "あとがき。"],
                  ["div.pgroup",
                   ["p", "atogaki"]]]
                 ) 
      end

    end
    describe 'inline' do
      it 'handle link' do
        text = " link to [link(http://github.com/skoji/noramark){noramark repository}]. \ncan you see this?"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
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

      it 'handle link with l' do
        text = "link to [l(http://github.com/skoji/noramark){noramark repository}]. \ncan you see this?"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
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

      it 'handle span' do
        text = "p.custom: this text is in [sp.keyword{custom}] class."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p.custom', 'this text is in ', ['span.keyword', 'custom'], ' class.'
                  ]]
                 )
      end

      it 'handle inline image' do
        text = "simple image [img(./image1.jpg, alt)]."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p',
                   'simple image ', ["img[src='./image1.jpg'][alt='alt']", ''], '.']]
                 )
      end

      it 'handle any inline' do
        text = "should be [strong{marked as strong}]."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'should be ', ['strong', 'marked as strong'],'.']]
                 )
      end

      it 'convert inline command within line block' do
        text = "h1: [tcy{20}]縦中横タイトル"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children).to eq ['h1', ['span.tcy', '20'], '縦中横タイトル']
      end

      it 'handle ruby' do
        text = "[ruby(とんぼ){蜻蛉}]の[ruby(めがね){眼鏡}]はみずいろめがね"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children).to eq ['div.pgroup', ['p', 
                                                                                     ['ruby', '蜻蛉', ['rp','('],['rt','とんぼ'],['rp', ')']],
                                                                                     'の',                                                                                   
                                                                                     ['ruby', '眼鏡', ['rp','('],['rt','めがね'],['rp', ')']],
                                                                                     'はみずいろめがね']]
      end

      it 'handle tatechuyoko' do
        text = "[tcy{10}]年前のことだった"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', ['span.tcy', '10'], '年前のことだった']
                 ])
      end

      it 'handle code inline' do
        text = "`this is inside code and [s{will not parsed}]`. you see?"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html        
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', ['code', 'this is inside code and [s{will not parsed}]'], '. you see?']
                 ])
      end
      it 'handle code escaped inline' do
        text = "\\`this is not inside code and [strong{will be parsed}]\\`. you see?"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html        
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', '`this is not inside code and ', ['strong', 'will be parsed'], '`. you see?']
                 ])
      end
      it 'handle code inline (long format)' do
        text = "[code.the-class{this is inside code and `backquote will not be parsed`}]. you see?"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html        
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', ['code.the-class', 'this is inside code and `backquote will not be parsed`'], '. you see?']
                 ])
      end
      it 'handle non-escaped inline' do
        text = "the text following will not be escaped: [noescape{&#169;}]"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html        
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'the text following will not be escaped: ©']
                 ])
      end
    end
    describe 'list' do
      it 'handle ordered list ' do
        text = "this is normal line.\n1. for the 1st.\n2. secondly, blah.\n3. and last...\nthe ordered list ends."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 3
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'this is normal line.']
                 ])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['ol', 
                  ['li', 'for the 1st.'],
                  ['li', 'secondly, blah.'],
                  ['li', 'and last...']
                 ])
        expect(body.element_children[2].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'the ordered list ends.']
                 ])
      end

      it 'handle unordered list ' do
        text = "this is normal line.\n* for the 1st.\n* secondly, blah.\n* and last...\nthe ordered list ends."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 3
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'this is normal line.']
                 ])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['ul', 
                  ['li', 'for the 1st.'],
                  ['li', 'secondly, blah.'],
                  ['li', 'and last...']
                 ])
        expect(body.element_children[2].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'the ordered list ends.']
                 ])
      end

      it 'handle nested unordered list ' do
        text = "this is normal line.\n* for the 1st.\n** nested.\n* and last...\nthe ordered list ends."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 3
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'this is normal line.']
                 ])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['ul', 
                  ['li', 'for the 1st.',
                   ['ul', 
                    ['li', 'nested.']]],
                  ['li', 'and last...']
                 ])
        expect(body.element_children[2].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'the ordered list ends.']
                 ])
      end

      it 'handle definition list ' do
        text = "this is normal line.\n;: 1st : this is the first definition\n;: 2nd : blah :blah.\n;: 3rd: this term is the last.\nthe list ends."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 3
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'this is normal line.']
                 ])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['dl', 
                  ['dt', '1st'],['dd', 'this is the first definition'],
                  ['dt', '2nd'],['dd', 'blah :blah.'],
                  ['dt', '3rd'],['dd', 'this term is the last.'],
                 ])
        expect(body.element_children[2].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'the list ends.']
                 ])
      end

      it 'handle long definition list ' do
        text = "this is normal line.\n;: 1st {\n this is the first definition\n}\n;: 2nd { \nblah :blah.\n}\n;: 3rd{\n this term is the last.\n}\nthe list ends."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 3
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'this is normal line.']
                 ])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['dl', 
                  ['dt', '1st'],['dd', ['div.pgroup', ['p', 'this is the first definition']]],
                  ['dt', '2nd'],['dd', ['div.pgroup', ['p', 'blah :blah.']]],
                  ['dt', '3rd'],['dd', ['div.pgroup', ['p', 'this term is the last.']]]
                 ])
        expect(body.element_children[2].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'the list ends.']
                 ])
      end
      it 'escape html in definition list' do
        text = ";:definition<div>:</div>"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['dl', 
                  ['dt', 'definition<div>'],['dd', '</div>']
                 ])
      end
    end
    
    describe 'metadata' do
      it 'specify stylesheets' do
        text = <<EOF
---
stylesheets: [ css/default.css, css/specific.css, [ css/iphone.css, 'only screen and (min-device-width : 320px) and (max-device-width : 480px)']]
---
text.

EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the document title')
        converted = noramark.html
        head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'the document title']
        expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='css/default.css']", '']
        expect(head.element_children[2].a).to eq ["link[rel='stylesheet'][type='text/css'][href='css/specific.css']", '']
        expect(head.element_children[3].a).to eq ["link[rel='stylesheet'][type='text/css'][media='only screen and (min-device-width : 320px) and (max-device-width : 480px)'][href='css/iphone.css']", '']

        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p',
                   'text.']])
      end

      it 'specify title' do
        text = "---\ntitle: the title of the book in the text.\n---\n\ntext."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'the title of the book in the text.']
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p',
                   'text.']])

      end

      it 'specify title on each page' do
        text = "---\ntitle: page1\n---\n\n1st page.\nnewpage:\n---\ntitle: page2\n---\nh1:2nd page"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title', paragraph_style: :use_paragraph_group)
        converted = noramark.html

        # 1st page
        head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'page1']
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p',
                   '1st page.']])
        # 2nd page
        head = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'page2']
        body = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['h1',"2nd page"])
      end

      it 'specify stylesheet on each page' do
        text = <<EOF
---
title: the document title
stylesheets: default.css
---
1st page.
newpage:
---
title: page 2
stylesheets: alternative.css
---
2nd page with alternative stylesheet.
newpage:
3rd page with default css.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title', paragraph_style: :use_paragraph_group)
        converted = noramark.html
        # 1st page
        head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'the document title']
        expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='default.css']", '']
        # 2nd page
        head = Nokogiri::XML::Document.parse(converted[1]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'page 2']
        expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='alternative.css']", '']
        # 3rd page
        head = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:head')
        expect(head.element_children[0].a).to eq ['title', 'the document title']
        expect(head.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='default.css']", '']
      end

      
      it 'ignore comments' do
        text = "// この行はコメントです\nここから、パラグラフがはじまります。\n // これもコメント\n「二行目です。」\n三行目です。\n\n// これもコメント\n\n ここから、次のパラグラフです。\n// 最後のコメントです"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2

        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'ここから、パラグラフがはじまります。'],
                  ['p.noindent', '「二行目です。」'],
                  ['p', '三行目です。']
                 ]
                 )

        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'ここから、次のパラグラフです。']]
                 )
      end

      it 'handle preprocessor' do
        text = "pre-preprocess text"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title') do
          |nora|
          nora.preprocessor do
            |t|
            t.gsub('pre-preprocess', 'post-process')
          end
        end
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup', 
                  ['p', 'post-process text'],
                 ]
                 )
      end
    end

    describe 'preformatted' do
      it 'convert preformatted text' do
        text = <<EOF
normal line.
  pre {//
d {
   this will not converted to div or p or pgroup.

line_command: this will be not converted too.
}
  //}
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(["pre", "d {\n   this will not converted to div or p or pgroup.\n\nline_command: this will be not converted too.\n}"])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end

      it 'should convert preformatted code' do
        text = <<EOF
normal line.
code {//
d {
   this will not converted to div or p or pgroup.
line_command: this will be not converted too.
}
//}
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(["pre", ["code", "d {\n   this will not converted to div or p or pgroup.\nline_command: this will be not converted too.\n}"]])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end

      it 'convert preformatted code with language' do
        text = <<EOF
normal line.
code {//ruby
# ruby code example.
"Hello, World".split(',').map(&:strip).map(&:to_sym) # => [:Hello, :World]
//}
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(["pre.code-ruby[data-code-language='ruby']", ["code", "# ruby code example.\n\"Hello, World\".split(',').map(&:strip).map(&:to_sym) # => [:Hello, :World]"]])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end

      it 'convert preformatted code with language fence format' do 
        text = <<EOF
normal line.
```ruby
# ruby code example.
"Hello, World".split(',').map(&:strip).map(&:to_sym) # => [:Hello, :World]
```
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(["pre.code-ruby[data-code-language='ruby']", ["code", "# ruby code example.\n\"Hello, World\".split(',').map(&:strip).map(&:to_sym) # => [:Hello, :World]"]])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end

      it 'convert preformatted text (simple notation)' do
        text = <<EOF
normal line.
pre {
this [l(link){link}] will not be converted.
line_command: this will be not converted too.
}
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(["pre", "this [l(link){link}] will not be converted.\nline_command: this will be not converted too."])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end
      it 'should convert preformatted code (simple notation)' do
        text = <<EOF
normal line.
code {
line_command: this will be not converted too.
}
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(["pre", ["code", "line_command: this will be not converted too."]])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end

      it 'convert preformatted text with caption' do
        text = <<EOF
normal line.
  pre(caption [sp.the-text{text}]) {//
d {
   this will not converted to div or p or pgroup.
line_command: this will be not converted too.
}
  //}
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ["div.pre",
                  ["p.caption", "caption ", ["span.the-text", "text"]],
                  ["pre", "d {\n   this will not converted to div or p or pgroup.\nline_command: this will be not converted too.\n}"]
                  ])

                  
      end

      it 'convert preformatted code with language fence format with caption' do 
        text = <<EOF
normal line.
```ruby(the caption text)
# ruby code example.
"Hello, World".split(',').map(&:strip).map(&:to_sym) # => [:Hello, :World]
```
normal line again.
EOF
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line."]])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ["div.pre", 
                  ["p.caption", "the caption text"],
                 ["pre.code-ruby[data-code-language='ruby']",
                  ["code", "# ruby code example.\n\"Hello, World\".split(',').map(&:strip).map(&:to_sym) # => [:Hello, :World]"]]])
        expect(body.element_children[2].selector_and_children)
          .to eq(["div.pgroup", ["p", "normal line again."]])
      end

    end

    describe 'markdown style' do
      it 'should convert markdown style heading' do
        text = "# タイトル です。\r\n\r\nこれは、セクションの中です。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 1
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'タイトル です。'],
                  ['div.pgroup', 
                   ['p', 'これは、セクションの中です。']]]
                 )
      end
      it 'should convert markdown style heading with empty body' do
        text = "# タイトルです。\n* 中身です。\n\n## 次のタイトルです。これから書きます。\n\n## ここもこれから。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'タイトルです。'],
                  ['ul', ['li', '中身です。']],
                  ['section',
                   ['h2', '次のタイトルです。これから書きます。']],
                  ['section',
                   ['h2', 'ここもこれから。']]])
      end
      it 'should markdown style heading interrupted by other headed section' do
        text = "# タイトルです。\r\nこれは、セクションの中です。\n # また次のセクションです。\n次のセクションの中です。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'タイトルです。'],
                  ['div.pgroup', 
                   ['p', 'これは、セクションの中です。']]])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'また次のセクションです。'],
                  ['div.pgroup', 
                   ['p', '次のセクションの中です。']]]
                 )
      end
      it 'should markdown style heading not interrupted by other explicit section' do
        text = "# タイトルです。\r\nこれは、セクションの中です。\n section {\n h2: また次のセクションです。\n入れ子になります。\n}\nこのように。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 1
        expect(body.element_children[0].selector_and_children)
          .to eq(
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
      it 'should markdown style heading not interrupted by other explicit section' do
        text = "# タイトルです。\r\nこれは、セクションの中です。\n ## また次のセクションです。{\n 入れ子になります。\n# 中にもかけます。\nさらにネストされます。\n}\nこのように。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 1
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'タイトルです。'],
                  ['div.pgroup', 
                   ['p', 'これは、セクションの中です。']],
                  ['section',
                   ['h2', 'また次のセクションです。'],
                   ['div.pgroup', 
                    ['p', '入れ子になります。']],
                   ['section',
                    ['h1', '中にもかけます。'],
                    ['div.pgroup', 
                     ['p', 'さらにネストされます。']]]],
                  ['div.pgroup', 
                   ['p', 'このように。']]]
                 )
      end

      it 'should markdown style explicit heading correctly nested' do
        text = "# head one \n in the top level section.\n ## second level section. { \n\n in the second level.\n}\n top level again."
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 1
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'head one'],
                  ['div.pgroup', 
                   ['p', 'in the top level section.']],
                  ['section',
                   ['h2', 'second level section.'],
                   ['div.pgroup', 
                    ['p', 'in the second level.']]],
                  ['div.pgroup', 
                   ['p', 'top level again.']]]
                 )
      end

      it 'should markdown style heading not interrupted by smaller section' do
        text = "# タイトルです。\r\nこれは、セクションの中です。\n ## また次のセクションです。\n 入れ子になります。\n### さらに中のセクション \nさらに入れ子になっているはず。\n# ここで次のセクションです。\n脱出しているはずです。"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        converted = noramark.html
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children.size).to eq 2
        expect(body.element_children[0].selector_and_children)
          .to eq(
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
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['section',
                  ['h1', 'ここで次のセクションです。'],
                  ['div.pgroup', 
                   ['p', '脱出しているはずです。']]])

      end
    end
    describe 'nonpaged mode' do
      it 'should create single html' do
        text = "some text\nnewpage:\nnext page"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title:'the document title')
        converted = noramark.render_parameter(nonpaged: true).html
        expect(converted.size).to eq 1
        body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
        expect(body.element_children[0].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'some text']])
        expect(body.element_children[1].selector_and_children)
          .to eq(
                 ['hr.page-break'])
        expect(body.element_children[2].selector_and_children)
          .to eq(
                 ['div.pgroup',
                  ['p', 'next page']])
      end
    end
    describe 'create file' do
      before { @basedir = File.join(File.dirname(__FILE__), 'created_files') }
      after { Dir.glob(File.join(@basedir, '*.xhtml')) { |file| File.delete file } }
      it 'should create default file' do
        text = "some text"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title: 'the title')
        noramark.html.write_as_files(directory: @basedir)
        expect(File.basename(Dir.glob(File.join(@basedir, '*.xhtml'))[0])).to match(/noramark_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}_00001.xhtml/)
      end
      it 'should create named file' do
        text = "some text\nnewpage:\nnext page"
        noramark = NoraMark::Document.parse(text, lang: 'ja', title:'the document title', document_name: 'nora-test-file', sequence_format: '%03d' )
        noramark.html.write_as_files(directory: @basedir)
        files = Dir.glob(File.join(@basedir, '*.xhtml')).map { |file| File.basename(file) }
        expect(files).to include 'nora-test-file_001.xhtml'
        expect(files).to include 'nora-test-file_002.xhtml'
      end
    end
    describe 'parse and create manual' do
      before {
        @here = File.dirname(__FILE__)
        @basedir = File.join(File.dirname(__FILE__), 'created_files') 
        @exampledir = File.join(@here, '..', 'example')
      }
      after { Dir.glob(File.join(@basedir, '*.xhtml')) { |file| File.delete file } }
      it 'should create valid html5' do
        noramark = NoraMark::Document.parse(File.open(File.join(@exampledir, 'noramark-reference-ja.nora'), 'rb:UTF-8').read, document_name: 'noramark-reference-ja')
        noramark.html.write_as_files(directory: @exampledir)
        jar = File.join(@here, 'jing-20091111/bin/jing.jar')
        schema = File.join(@here, 'epub30-schemas/epub-xhtml-30.rnc')
        original_file = File.join(@exampledir, 'noramark-reference-ja_00001.xhtml')
        file_to_validate = File.join(@basedir, 'noramark-reference-ja_00001.xhtml')
        File.open(original_file) do
          |original|
          nokogiri_doc = Nokogiri::XML::Document.parse(original)
          set = nokogiri_doc.xpath('//xmlns:pre[@data-code-language]')
          set.remove_attr('data-code-language')
          File.open(file_to_validate, 'w+') do
            |to_validate|
            to_validate << nokogiri_doc.to_s
          end
        end
        @stdout = capture(:stdout) do 
          puts %x(java -jar #{jar} -c #{schema} #{file_to_validate})
        end
        expect(@stdout.strip).to eq ""
      end
    end
    describe 'table of contents' do
      before do
        @text = <<EOF
---
lang: ja
title: title
---
# [strong{chapter 1}]
text
## section 1-1
text
newpage:
section {
h6: [strong{some column}]
text
}
EOF
        @noramark = NoraMark::Document.parse(@text, document_name: 'nora')
      end
      it 'should assign ids to headers' do
        body = Nokogiri::XML::Document.parse(@noramark.html[0]).root.at_xpath('xmlns:body')
        h1 = body.at_xpath('//xmlns:h1')
        expect(h1.selector remove_id: false).to eq "h1#heading_index_1"
        h2 = body.at_xpath('//xmlns:h2')
        expect(h2.selector remove_id: false).to eq "h2#heading_index_2"
        body = Nokogiri::XML::Document.parse(@noramark.html[1]).root.at_xpath('xmlns:body')
        h6 = body.at_xpath('//xmlns:h6')
        expect(h6.selector remove_id: false).to eq "h6#heading_index_3"
      end
      it 'should generate tocs' do
        toc = @noramark.html.toc
        expect(toc.size).to eq 3
        expect(toc[0])
          .to eq({link: "nora_00001.xhtml#heading_index_1", level: 1, text: "chapter 1"})
        expect(toc[1])
          .to eq({link: "nora_00001.xhtml#heading_index_2", level: 2, text: "section 1-1"})
        expect(toc[2])
          .to eq({link: "nora_00002.xhtml#heading_index_3", level: 6, text: "some column"})
      end
    end
    it 'should raise error' do
      text = "d {\n block is\nd {\n nested but\nd {\n not terminated }"
      expect { NoraMark::Document.parse(text, lang: 'ja', title: 'foo') }.to raise_error KPeg::CompiledParser::ParseError
    end
  end
  describe 'video' do
    it 'should render video' do
      text = "this text includes [video(video.mp4)[poster: poster.jpg]{alternate message}]"
      nora = NoraMark::Document.parse(text)
      converted = nora.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children)
        .to eq(
               ['p', 'this text includes ',
                ["video[src='video.mp4'][poster='poster.jpg']", 'alternate message']]
               )
    end
    it 'should render video with autoplay and controls' do
      text = "this text includes [video(video.mp4, autoplay, controls)[poster: poster.jpg]]"
      nora = NoraMark::Document.parse(text)
      converted = nora.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children)
        .to eq(
               ['p', 'this text includes ',
                ["video[src='video.mp4'][poster='poster.jpg'][autoplay='autoplay'][controls='controls']", '']]
               )
    end
  end
  describe 'audio' do
    it 'should render audio' do
      text = "this text includes [audio(audio.mp3)[volume: 0.2]{alternate message}]"
      nora = NoraMark::Document.parse(text)
      converted = nora.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children)
        .to eq(
               ['p', 'this text includes ',
                ["audio[src='audio.mp3'][volume='0.2']", 'alternate message']]
               )
    end
    it 'should render audio with autoplay and controls' do
      text = "this text includes [audio(audio.mp3, autoplay, controls)]"
      nora = NoraMark::Document.parse(text)
      converted = nora.html
      body = Nokogiri::XML::Document.parse(converted[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children)
        .to eq(
               ['p', 'this text includes ',
                ["audio[src='audio.mp3'][autoplay='autoplay'][controls='controls']", '']]
               )
    end
  end
  describe 'Frontmatter MetaData' do
    it 'handle namespace' do
      text = <<EOF
---
namespace: { epub: "http://www.idpf.org/2007/ops" }
---
text
EOF
      converted = NoraMark::Document.parse(text)
      xhtml = Nokogiri::XML::Document.parse(converted.html[0])  
      expect(xhtml.root.namespaces['xmlns:epub'])
        .to eq 'http://www.idpf.org/2007/ops'
    end

    it 'handle meta tag' do
      text = <<EOF
---
meta: { name: mymeta, content: mycontent }
namespace: { epub: "http://www.idpf.org/2007/ops" }
---
text
EOF
      converted = NoraMark::Document.parse(text)
      xhtml = Nokogiri::XML::Document.parse(converted.html[0])
      expect(xhtml.root.at_xpath('xmlns:head/xmlns:body')).to be_nil
      expect(xhtml.root.at_xpath('xmlns:head/xmlns:meta').selector_and_children)
        .to eq ["meta[name='mymeta'][content='mycontent']"]
    end
  end
end

