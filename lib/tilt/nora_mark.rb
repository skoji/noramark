require 'tilt'
require 'nora_mark'

module Tilt
  class NoraMarkTemplate < Template
    protected

    def prepare
      @document = NoraMark::Document.parse(data).render_parameter(nonpaged: true)
    end

    def evaluate(_scope, _locals)
      @html ||= @document.html[0]
    end
  end

  register NoraMarkTemplate, 'nora'
end
