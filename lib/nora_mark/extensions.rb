module NoraMark
  class Extensions
    def self.register_generator(generator)
      if !generator.respond_to? :name
        generator = load_generator(generator)
      end
      NoraMark::Document.register_generator(generator)
    end

    def self.unregister_generator(generator)
      NoraMark::Document.unregister_generator(generator)
    end

    def self.const_get_if_available(name)
      name.split(/::/).inject(Object) { |o, c|
        o.const_get(c) if !o.nil? and o.const_defined? c
      }
    end

    private

    def self.load_generator(generator)
      module_name = "NoraMark::#{generator.to_s.capitalize}::Generator"
      generator_module = const_get_if_available(module_name)
      return generator_module unless generator_module.nil?

      path = "#{generator.to_s.downcase}.rb"
      current_dir_path = File.expand_path(File.join('.', '.noramark-plugins', path))
      home_dir_path = File.expand_path(File.join(ENV['HOME'], '.noramark-plugins', path))
      if File.exist? current_dir_path
        require current_dir_path
      elsif File.exist? home_dir_path
        require home_dir_path
      else
        require "nora_mark_#{generator.to_s.downcase}"
      end
      const_get_if_available(module_name)
    end
  end
end
