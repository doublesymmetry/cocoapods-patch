require 'spec_helper'

describe Pod::Command::Patch::Apply do
  describe 'CLAide' do
    it 'registers it self' do
      expect(Pod::Command.parse(%w{ patch apply POD_NAME })).to be_an_instance_of Pod::Command::Patch::Apply
    end
  end
end