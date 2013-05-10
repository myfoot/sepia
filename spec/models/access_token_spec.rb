require 'spec_helper'

describe AccessToken do
  let(:user) { User.create(name: 'hoge') }
  let(:access_token) { AccessToken.create(user_id: user.id, token: 'aaa', secret: 'bbb', provider: :twitter)}

  describe "relations" do
    describe "#user" do
      subject { access_token.user }
      it "should be belongs to user" do
        expect(subject).to eq(user)
      end
    end
  end

end
