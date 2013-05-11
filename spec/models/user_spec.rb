require 'spec_helper'

describe User do
  let(:valid_user) { User.new(name: "test-user", email: "hoge@gmail.com") }

  describe "validations" do
    describe "name" do
      before do
        @noname_user = valid_user.tap{|u|
          u.name = ""
          u.save
        }
      end
      it "required" do
        expect(@noname_user).not_to be_valid
      end
    end
  end
end
