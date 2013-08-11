# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clients::Social do

  describe ".find_class" do
    context :twitter do
      subject { Clients::Social.find_class(:twitter) }
      it { should be_== Clients::Social::TwitterClients }
    end
    context :facebook do
      subject { Clients::Social.find_class(:facebook) }
      it { should be_== Clients::Social::Facebook }
    end
    context :google_oauth2 do
      subject { Clients::Social.find_class(:google_oauth2) }
      it { should be_== Clients::Social::Google }
    end
    context "invalid procider" do
      subject { Clients::Social.find_class(:hoge) }
      it { should be_nil }
    end
  end
end
