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

#(split-me) section 2

  next text.

# section 3
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
  it 'can split page' do
    @parsed.add_transformer(generator: :html) do
      modify type: :Root do
        def split page
          splitted = page.children.inject([]) do |result, node|
            if node.params && node.params.select { |param| param.text == 'split-me' }.size > 0
              rest = node.remove_following
              as_page = rest.shift
              result << NoraMark::Page.new([as_page], as_page.line_no)
              result = result + split(NoraMark::Page.new(rest, rest[0].line_no)) if rest.size > 0
            end
            result
          end
          splitted.unshift page
        end
        @node.children.each do |page|
          splitted = split page
          if (splitted.size > 1)
            page = splitted.shift
            splitted.inject(page) do |page_before, page_after|
              page_before.after(page_after)
              page_after
            end
            @node.assign_pageno
          end
        end
      end
    end
    converted = @parsed.html
    expect(converted.size).to eq(3)
    body = Nokogiri::XML::Document.parse(@parsed.html[0]).root.at_xpath('xmlns:body')
    expect(body.element_children[0].selector_and_children())
      .to eq(
            ['section', ['h1', 'section 1'], 
             ['div.class-1', ['div.pgroup', ['p', 'text is here']]]]
          )

    body = Nokogiri::XML::Document.parse(@parsed.html[1]).root.at_xpath('xmlns:body')
    expect(body.element_children[0].selector_and_children())
      .to eq(
            ["section", ["h1", "section 2"], 
             ["div.pgroup", ["p", "next text."]]]
          )
  end

  it 'can add frontmatter' do
    @parsed.add_transformer(generator: :html) do
      modify type: :Root do
        def split page
          splitted = page.children.inject([]) do |result, node|
            if node.params && node.params.select { |param| param.text == 'split-me' }.size > 0
              rest = node.remove_following
              as_page = rest.shift
              new_frontmatter = NoraMark::Frontmatter.new(['stylesheets: new_stylesheet.css'], as_page.line_no)

              result << NoraMark::Page.new([new_frontmatter, as_page], as_page.line_no)
              result = result + split(NoraMark::Page.new(rest, rest[0].line_no)) if rest.size > 0
            end
            result
          end
          splitted.unshift page
        end

        @node.children.each do |page|
          splitted = split page
          if (splitted.size > 1)
            page = splitted.shift
            splitted.inject(page) do |page_before, page_after|
              page_before.after(page_after)
              page_after
            end
            @node.assign_pageno
          end
        end
        
      end
    end
    html = @parsed.html
    body1 = Nokogiri::XML::Document.parse(html[0]).root.at_xpath('xmlns:body')
    expect(body1.element_children[0].selector_and_children())
      .to eq(
            ['section', ['h1', 'section 1'], 
             ['div.class-1', ['div.pgroup', ['p', 'text is here']]]]
          )
    head2 = Nokogiri::XML::Document.parse(html[1]).root.at_xpath('xmlns:head')
    expect(head2.element_children[1].a).to eq ["link[rel='stylesheet'][type='text/css'][href='new_stylesheet.css']", '']

    body2 = Nokogiri::XML::Document.parse(@parsed.html[1]).root.at_xpath('xmlns:body')
    expect(body2.element_children[0].selector_and_children())
      .to eq(
            ["section", ["h1", "section 2"], 
             ["div.pgroup", ["p", "next text."]]]
          )
    
    
  end
end
