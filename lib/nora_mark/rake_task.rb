require 'nora_mark'
require 'rake/tasklib'

module NoraMark
  class RakeTask < ::Rake::TaskLib
    attr_accessor :lang, :page_number_digits, :title, :stylesheets, :write_toc_file
    def initialize(lang: 'en')
      @preprocessors = []
      @transformers = []
      yield self if block_given?
      @lang ||= lang
      @page_number_digits ||= 5
      define
    end

    def add_preprocessor(&block)
      @preprocessors << block;
    end

    def add_transformer(&block)
      @transformers << block;
    end

    def html
      return @nora.html if !@nora.nil?
    end

    def toc
      return @nora.html.toc if !@nora.nil? && !@nora.html.nil?
    end

    def define
      desc "rule for *-nora.txt to *-nora_xxx.html. Use *-nora-transform.rb on same directory as transformer"
      rule( /-((nora)|(arti))_[0-9]{#{page_number_digits}}\.xhtml/ =>
            proc {|task_name|
              task_name.sub(/^(.+?-((nora)|(arti)))_[0-9]{#{page_number_digits}}\.xhtml/, '\1.txt')
            }) do
        |t|

        dir =  File.dirname File.expand_path(t.source)
        basename = File.basename(t.source, '.txt')
        transformer_name = File.join dir, basename + '-transform.rb'
        parameters = {
          :lang => @lang.to_s,
          :sequence_format => "%0#{page_number_digits}d",
          :document_name=>t.name.sub(/_[0-9]{#{page_number_digits}}\.xhtml/, '')
        }
        parameters[:stylesheets] = @stylesheets unless @stylesheets.nil?
        parameters[:title] = @title unless @title.nil?
        @nora =
          NoraMark::Document.parse(
                                   File.open(t.source), parameters) do
          |doc|
          @preprocessors.each do
            |prepro|
            doc.preprocessor(&prepro)
          end
          @transformers.each do
            |transformer|
            doc.add_transformer(&transformer)
          end
          if File.exist? transformer_name
            doc.add_transformer(text: File.open(transformer_name).read)
          end
        end
        @nora.html.write_as_files
        if (@write_toc_file)
          @nora.html.write_toc_as_file
        end
      end
      
    end
  end
end
