#!/usr/bin/env rake
require "bundler/gem_tasks"

rule(/\.kpeg\.rb/ => proc {|task_name| task_name.sub(/kpeg\.rb$/, 'kpeg')}) do
  |t|
  system "kpeg -f #{t.prerequisites[0]}"
end

desc "run rspec"
task :test => ["lib/arti_mark/parser.kpeg.rb"] do
  system 'rspec'
end
