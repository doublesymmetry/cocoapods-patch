require 'spec_helper'

describe Pod::Command::Patch do
  describe 'CLAide' do
    it 'registers it self' do
      expect(Pod::Command.parse(%w{ patch })).to be_an_instance_of Pod::Command::Patch
    end
  end
end