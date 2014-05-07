module NoraMark
  class Extensions
    def self.register_generator(generator)
      if !generator.respond_to? :name
        generator = load_generator(generator)
      end
      NoraMark::Document.register_generator(generator)
    end
    
    def load_generator(generator)
      module_name = '::NoraMark::#{generator.to_s.capitalize}::Generator'
      return const_get(module_name) if const_defined? module_name.to_sym
      path = "#{generator.to_s.lowercase}.rb"
      current_dir_path = File.expand_path(File.join('.', '.noramark-plugins', path))
      home_dir_path = File.expand_path(File.join(ENV['HOME'], '.noramark-plugins', path))
      if File.exist? current_dir_path
        require current_dir_path
      elsif File.exist? home_dir_path
        require home_dir_path
      else
        require "noramark/#{generator.to_s.lowercase}"
      end
      const_defined?(module_name.to_sym) ? const_get(module_name) : nil
    end
  end
end
