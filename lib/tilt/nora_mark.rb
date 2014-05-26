require 'tilt'
require 'nora_mark'

module Tilt
  class NoraMarkTemplate < Template
    protected

    def prepare
      @document = NoraMark::Document.parse(data).render_parameter(nonpaged: true)
    end

    def evaluate(scope, locals, &block)
      @html ||= @document.html[0]
    end
  end

  register NoraMarkTemplate, 'nora'
end
