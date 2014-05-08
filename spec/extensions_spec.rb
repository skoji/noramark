# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe NoraMark::Extensions do
  describe "register generator in the path" do
    before(:each) do
      if NoraMark.const_defined? :Tester
        NoraMark::Extensions.unregister_generator(:tester)
      end
      @test_plugin_dir = File.dirname(__FILE__) + '/fixtures/test-plugins'
      $:.unshift @test_plugin_dir
    end
    it 'load generator from path' do
      NoraMark::Extensions.register_generator(:tester)
      nora = NoraMark::Document.parse('text')
      expect(nora.tester).to eq 'it is just a test.'
    end
    it 'load generator from path using frontmatter' do
      nora = NoraMark::Document.parse("---\ngenerator: tester\n---\ntext")
      expect(nora.tester).to eq 'it is just a test.'
    end
    after(:each) do
      $:.delete @test_plugin_dir
    end
    
  end
end

