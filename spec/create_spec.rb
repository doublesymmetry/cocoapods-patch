require 'spec_helper'

describe Pod::Command::Patch::Create do
  describe 'CLAide' do
    it 'registers it self' do
      expect(Pod::Command.parse(%w{ patch create POD_NAME })).to be_an_instance_of Pod::Command::Patch::Create
    end
  end
end