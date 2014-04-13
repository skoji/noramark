# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe NoraMark::Transformer do
  before do
    @text = <<EOF
---
title: the title
lang: ja
custom_data: [custom1, custom2]
---
# section 1

d.class-1 {
  text is here
}

EOF
    @parsed = NoraMark::Document.parse(@text)
  end
  it 'can access frontmatter' do
    @parsed.add_transformer(generator: :html) do
      modify 'd' do
        @node.classes = [@frontmatter['custom_data'][0]]
      end
    end
    body = Nokogiri::XML::Document.parse(@parsed.html[0]).root.at_xpath('xmlns:body')
    expect(body.element_children[0].selector_and_children())
      .to eq(
             ['section', ['h1', 'section 1'], 
              ['div.custom1', ['div.pgroup', ['p', 'text is here']]]]
             )
  end
end
