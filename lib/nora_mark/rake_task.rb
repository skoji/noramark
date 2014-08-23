require 'nora_mark'
require 'rake/tasklib'

module NoraMark
  class RakeTask < ::Rake::TaskLib
    attr_accessor :lang, :page_number_digits
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

    def define
      desc "rule for *-nora.txt to *-nora_xxx.html. Use *-nora-transform.rb on same directory as transformer"
      rule( /-((nora)|(arti))_[0-9]{#{page_number_digits}}\.xhtml/ =>
            proc {|task_name|
              task_name.sub(/^(.+?-((nora)|(arti)))_[0-9]{#{page_number_digits}}\.xhtml/, '\1.txt')
            }) do
        |t|

        dir =  File.dirname File.expand_path(t.source)
        transformer_name = File.join dir, File.basename(t.source, '.txt') + '-transform.rb'
        nora =
          NoraMark::Document.parse(
                                   File.open(t.source),
                                   :lang => @lang.to_s,
                                   :sequence_format => "%0#{page_number_digits}d",
                                   :document_name=>t.name.sub(/_[0-9]{#{page_number_digits}}\.xhtml/, '')) do
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
        nora.html.write_as_files
      end
      
    end
  end
end
