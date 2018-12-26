require_relative 'spec_helper'
require 'pathname'
require 'tilt/nora_mark'

describe Tilt::NoraMarkTemplate do
  let(:fixtures_dir) { Pathname.new(__dir__) + 'fixtures/tilt' }
  subject { Tilt.new(fixtures_dir + 'nora/sample.nora') }

  it "should be registered for '.nora' files" do
    expect(subject).to be_an_instance_of(Tilt::NoraMarkTemplate)
  end

  it "should convert '.nora' files to HTML" do
    expect(subject.render).to eq((fixtures_dir + 'html/sample.html').read)
  end
end
