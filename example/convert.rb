require 'nora_mark'

Dir.chdir(File.dirname(__FILE__)) do
  doc = NoraMark::Document.parse(File.open('noramark-reference-ja.nora'), document_name: 'noramark-reference-ja')
  doc.html.write_as_files
end

