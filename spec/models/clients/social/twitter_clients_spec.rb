# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clients::Social::TwitterClients do
  let(:token) { AccessToken.new(name: "user_name") }
  let(:client) { Clients::Social::TwitterClients.new(token) }
  let(:last_date) { Time.now }
  let(:page) { 2 }

  describe "#photos" do
    before do
      client1 = double("Clients::Social::TwitPic")
      client1.should_receive(:photos).with(last_date, page).and_return([1])
      client2 = double("Clients::Social::TwitPic")
      client2.should_receive(:photos).with(last_date, page).and_return([2, 3])

      client.stub(:clients).and_return([client1, client2])
    end
    subject { client.photos(last_date, page) }
    it "クライアント毎の結果をまとめて返す" do
      expect(subject).to match_array([1, 2, 3])
    end
  end
end

