# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clients::Social do

  describe ".find_class" do
    context :twitter do
      subject { Clients::Social.find_class(:twitter) }
      it { should eq Clients::Social::TwitterClients }
    end
    context :facebook do
      subject { Clients::Social.find_class(:facebook) }
      it { should eq Clients::Social::Facebook }
    end
    context :google_oauth2 do
      subject { Clients::Social.find_class(:google_oauth2) }
      it { should eq Clients::Social::Google }
    end
    context :instagram do
      subject { Clients::Social.find_class(:instagram) }
      it { should eq Clients::Social::InstagrAm }
    end
    context "invalid procider" do
      subject { Clients::Social.find_class(:hoge) }
      it { should be_nil }
    end
  end

end
