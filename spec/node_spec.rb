require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe NoraMark::Node do 
  describe 'node manipulation' do
    before do
      @text = <<EOF
1st line.
d.the_class {
3rd line.
}
5th line.
EOF
    end
    it 'should access line number' do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      expect(page.children.size).to eq 3
      expect(page.line_no).to eq 1
      expect(page.children[0].line_no).to eq 1
      expect(page.children[1].line_no).to eq 2
      expect(page.children[2].children[0].line_no).to eq 5
    end

    it 'replace existing node'  do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      first_pgroup = page.children[0]
      line_no = first_pgroup.line_no
      new_node = NoraMark::ParagraphGroup.new(['the_id'], ['the_class'], [], {}, [ NoraMark::Text.new("replaced.", line_no)],  line_no)
      first_pgroup.replace(new_node)
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children(remove_id: false))
        .to eq(
               ['p#the_id.the_class', 'replaced.'])
    end

    it 'replace existing node by multiple nodes' do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      first_pgroup = page.children[0]
      line_no = first_pgroup.line_no
      new_node1 = NoraMark::ParagraphGroup.new(['the_id'], ['the_class'], [], {}, [ NoraMark::Text.new("replaced.", line_no)],  line_no)
      new_node2 = NoraMark::ParagraphGroup.new(['the_id2'], ['the_class2'], [], {}, [ NoraMark::Text.new("replaced2.", line_no)],  line_no)
      first_pgroup.replace([new_node1, new_node2])
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children(remove_id: false))
        .to eq(
               ['p#the_id.the_class', 'replaced.'])
      expect(body.element_children[1].selector_and_children(remove_id: false))
        .to eq(
               ['p#the_id2.the_class2', 'replaced2.'])
      expect(body.element_children[2].selector_and_children(remove_id: false))
        .to eq(
               ['div.the_class', ['p', '3rd line.']])
    end

    it 'wraps existing node'  do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      first_pgroup = page.children[0]
      line_no = first_pgroup.line_no
      new_node = NoraMark::Block.new('div', ['the_id'], ['the_class'], [], {}, [
                                                                                NoraMark::Block.new('p', [], [], [], {}, [
                                                                                NoraMark::Text.new("replaced.", line_no)], line_no)
                                                                               ],  line_no)
      first_pgroup.wrap(new_node)
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children(remove_id: false))
        .to eq(['div#the_id.the_class', ['p', '1st line.'], ['p', 'replaced.']])
    end

    it 'append to  existing node'  do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      first_pgroup = page.children[0]
      line_no = first_pgroup.line_no
      new_node = NoraMark::ParagraphGroup.new(['the_id'], ['the_class'], [], {}, [ NoraMark::Text.new("added.", line_no)],  line_no)
      first_pgroup.after(new_node)
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children(remove_id: false))
        .to eq(
               ['p', '1st line.'])
      expect(body.element_children[1].selector_and_children(remove_id: false))
        .to eq(
               ['p#the_id.the_class', 'added.'])
      expect(body.element_children[2].selector_and_children(remove_id: false))
        .to eq(
               ['div.the_class', ['p', '3rd line.']])
    end

    it 'append to the last existing node'  do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      last_pgroup = page.children[2]
      line_no = last_pgroup.line_no
      new_node = NoraMark::ParagraphGroup.new(['the_id'], ['the_class'], [], {}, [ NoraMark::Text.new("added.", line_no)],  line_no)
      last_pgroup.after(new_node)
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[1].selector_and_children(remove_id: false))
        .to eq(
               ['div.the_class', ['p', '3rd line.']])
      expect(body.element_children[2].selector_and_children(remove_id: false))
        .to eq(
               ['p', '5th line.'])
      expect(body.element_children[3].selector_and_children(remove_id: false))
        .to eq(
               ['p#the_id.the_class', 'added.'])
    end
    
    it 'prepend to existing node'  do
      noramark = NoraMark::Document.parse(@text)
      page = noramark.root.children[0]
      first_pgroup = page.children[0]
      line_no = first_pgroup.line_no
      new_node = NoraMark::ParagraphGroup.new(['the_id'], ['the_class'], [], {}, [ NoraMark::Text.new("added.", line_no)],  line_no)
      first_pgroup.before(new_node)
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children(remove_id: false))
        .to eq(
               ['p#the_id.the_class', 'added.'])
      expect(body.element_children[1].selector_and_children(remove_id: false))
        .to eq(
               ['p', '1st line.'])
      expect(body.element_children[2].selector_and_children(remove_id: false))
        .to eq(
               ['div.the_class', ['p', '3rd line.']])
    end

    it 'modify existing node by DSL' do
      text = "1st line.\nfoobar(title)[level: 3] {\n in the section.\n}\n# section 2."
      noramark = NoraMark::Document.parse(text, lang: 'ja')

      noramark.add_transformer(generator: :html) do
        modify 'foobar' do
          @node.name = 'section'
          @node.prepend_child block("h#{@node.n[:level]}", @node.p[0])
        end
      end
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children())
        .to eq(
               ['div.pgroup', [ 'p', '1st line.' ]])
      expect(body.element_children[1].selector_and_children())
        .to eq(
               ['section', [ 'h3', 'title' ], ['div.pgroup',  ['p', 'in the section.']]])
      expect(body.element_children[2].selector_and_children())
        .to eq(
               ['section', [ 'h1','section 2.' ]])
    end
    it 'replace existing node by DSL' do
      text = "1st line.\nfoobar(title)[level: 3] {\n in the section.\n}\n# section 2."
      noramark = NoraMark::Document.parse(text, lang: 'ja')

      noramark.add_transformer(generator: :html) do
        replace 'foobar' do
          block('section',
                [
                 block( "h#{@node.named_params[:level]}", @node.params[0]),
                ] + @node.children)
        end
      end
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children())
        .to eq(
               ['div.pgroup', [ 'p', '1st line.' ]])
      expect(body.element_children[1].selector_and_children())
        .to eq(
               ['section', [ 'h3', 'title' ], ['div.pgroup',  ['p', 'in the section.']]])
      expect(body.element_children[2].selector_and_children())
        .to eq(
               ['section', [ 'h1','section 2.' ]])
    end
    it 'generate complex-style headed section' do
      text = <<EOF
---
lang: ja
---

# 見出し
sub: 副見出し

パラグラフ。
パラグラフ。

EOF
      noramark = NoraMark::Document.parse(text)
      noramark.add_transformer(generator: :html) do
        replace({:type => :HeadedSection}) do
          header = block('header',
                         block('div',
                               block("h#{@node.level}", @node.heading),
                               classes: ['hgroup'])) 
          if (fc = @node.first_child).name == 'sub'
            fc.name = 'p'
            fc.classes = ['subh']
            header.first_child.append_child fc 
          end
          body = block('div', @node.children, classes:['section-body'])
          block('section', [ header, body ], template: @node)
        end
      end
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children())
        .to eq(
               ['section', [ 'header', ['div.hgroup', ['h1', '見出し'], ['p.subh', '副見出し']]],
                ['div.section-body',
                 ['div.pgroup', ['p', 'パラグラフ。'], ['p', 'パラグラフ。']]]])
    end
    it 'converts my markup' do
      text = "speak(Alice): Alice is speaking.\nspeak(Bob): and this is Bob."
      noramark = NoraMark::Document.parse(text)
      noramark.add_transformer(generator: :html) do
        modify "speak" do
          @node.name = 'p'
          @node.prepend_child inline('span', @node.params[0], classes: ['speaker'])
        end
      end
      body = Nokogiri::XML::Document.parse(noramark.html[0]).root.at_xpath('xmlns:body')
      expect(body.element_children[0].selector_and_children())
        .to eq(
               ['p', ['span.speaker', 'Alice'], 'Alice is speaking.'])
      expect(body.element_children[1].selector_and_children())
        .to eq(
               ['p', ['span.speaker', 'Bob'], 'and this is Bob.'])

    end
    

    it 'should reparent tree' do
      text = <<EOF
1st line.
d {
in the div
}
*: ul item
text [s{with inline}] within
EOF
      root = NoraMark::Document.parse(text).root

      expect(root.parent).to be nil
      expect(root.prev).to be nil
      expect(root.next).to be nil
      expect(root.content).to be nil

      expect(root.children.size).to eq 1
      page = root.first_child
      expect(root.children[0]).to eq page
      expect(root.last_child).to eq page
      expect(page.parent).to eq root
      expect(page.prev).to be nil
      expect(page.next).to be nil

      first_pgroup = page.first_child
      expect(first_pgroup.class).to be NoraMark::ParagraphGroup
      expect(first_pgroup.parent).to eq page
      expect(first_pgroup.children.size).to eq 1
      expect(first_pgroup.prev).to be nil

      paragraph = first_pgroup.first_child
      expect(paragraph.class).to be NoraMark::Paragraph
      expect(paragraph.parent).to be first_pgroup
      expect(paragraph.prev).to be nil
      expect(paragraph.next).to be nil
      expect(paragraph.children.size).to eq 1
      text = paragraph.first_child
      expect(text.class).to be NoraMark::Text
      expect(text.content).to eq '1st line.'
      expect(text.children.size).to eq 0
      expect(text.prev).to be nil
      expect(text.next).to be nil
      expect(text.parent).to eq paragraph

      second_div = first_pgroup.next
      expect(second_div.class).to be NoraMark::Block
    end
  end
end
