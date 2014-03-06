#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

rule(/\.kpeg\.rb/ => proc {|task_name| task_name.sub(/kpeg\.rb$/, 'kpeg')}) do
  |t|
  system "kpeg -f #{t.prerequisites[0]}"
end

RSpec::Core::RakeTask.new(:spec)

desc "run rspec"
task :test => ["lib/nora_mark/parser.kpeg.rb", :spec]

