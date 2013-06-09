# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clients::Social::TwitPic do
  let(:token) { AccessToken.new(name: "user_name") }
  let(:client) { Clients::Social::TwitPic.new(token) }
  let(:max_json_array) {
    Clients::Social::TwitPic::MAX_PER_PAGE.times.map{|i|
      {"short_id" =>  "id-#{100-i}", "type" =>  "jpg", "message" => "m-#{i}", "width" => 100+i, "height" => 200+i, "timestamp" => "2013-06-09 14:10:#{59-i}"} # UTC
    }
  }
  let(:few_json_array) {
    (Clients::Social::TwitPic::MAX_PER_PAGE - 10).times.map{|i|
      {"short_id" =>  "id-#{10-i}", "type" =>  "jpg", "message" => "m-#{i}", "width" => 100+i, "height" => 200+i, "timestamp" => "2013-06-08 14:10:#{59-i}"} # UTC
    }
  }
  
  describe "#photos" do
    context "データが無い場合" do
      subject { client.photos }
      before do
        client.stub(:page_images).and_return([])
      end
      it "空配列" do
        expect(subject).to match_array([])
      end
    end

    context "日付指定なしの場合" do
      subject { client.photos }
      before do
        client.should_receive(:page_images).once.and_return(max_json_array)
        client.should_receive(:page_images).once.and_return(few_json_array)
      end
      it "全データを取得する" do
        expect(subject.size).to eq(max_json_array.size + few_json_array.size)
        expect(subject.last.platform_id).to eq(few_json_array.last["short_id"])
      end
    end

    context "日付指定ありの場合" do
      subject { client.photos Time.parse("2013-06-09 23:10:57") }
      before do
        client.should_receive(:page_images).once.and_return(max_json_array)
      end
      it "指定した日付より後のデータを取得する" do
        expect(subject.size).to eq(2)
        expect(subject.last.platform_id).to eq(max_json_array[1]["short_id"])
      end
    end

    context "ページ指定あり場合" do
      before do
        client.should_receive(:page_images).once.and_return(few_json_array)
      end
      it "指定ページ以降のデータを取得する" do
        client.should_receive(:uri).once.with(anything(), 2);
        client.photos nil, 2
      end
    end
  end
end
