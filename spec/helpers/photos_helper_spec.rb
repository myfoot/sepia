require 'spec_helper'

describe PhotosHelper do
  describe "#icon_class" do
    context "twitter" do
      subject{ helper.icon_class('twitter') }
      it { should eq('icon-twitter') }
    end
    context "facebook" do
      subject{ helper.icon_class('facebook') }
      it { should eq('icon-facebook') }
    end
    context "twitter" do
      subject{ helper.icon_class('google_oauth2') }
      it { should eq('icon-google-plus') }
    end
    context "twitter" do
      subject{ helper.icon_class('instagram') }
      it { should eq('icon-instagram') }
    end
    context "twitter" do
      subject{ helper.icon_class('hoge') }
      it { should eq('icon-question') }
    end
  end
end
