require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Patch do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ patch }).should.be.instance_of Command::Patch
      end
    end
  end
end

