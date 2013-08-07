require 'spec_helper'

describe ApplicationHelper do
  describe "#format_time" do
    before(:each) do
      @timezone_origin = ENV['TZ']
      ENV['TZ'] = 'Asia/Tokyo'
    end

    after(:each) do
      ENV['TZ'] = @timezone_origin
    end

    describe "日付文字列" do
      it "ローカル時刻に合わせてフォーマットされる" do
        expect(helper.format_time("2013-08-03 03:22:29 UTC")).to eq("2013-08-03 12:22:29")
        expect(helper.format_time("2013-08-03T09:08:41.000Z")).to eq("2013-08-03 18:08:41")
      end

      it "フォーマットを指定できる" do
        utc = "2013-08-03 03:22:29 UTC"
        format = "%Y/%m/%d"
        expect(helper.format_time(utc, format)).to eq("2013/08/03")
      end
    end

    describe "文字列以外のオブジェクト" do
      it "ローカル時刻に合わせてフォーマットされる" do
        utc = Time.new(2013, 8, 7, 15, 30, 45).utc
        expect(helper.format_time(utc)).to eq("2013-08-07 15:30:45")
      end
    end
  end
end

