require 'spec_helper'

describe ApplicationHelper do
  describe "#format_time" do
    context "日付文字列" do
      it "ローカル時刻に合わせてフォーマットされる" do
        expect(helper.format_time("2013-08-03 03:22:29 UTC")).to eq("2013-08-03 12:22:29")
        expect(helper.format_time("2013-08-03T09:08:41.000Z")).to eq("2013-08-03 18:08:41")
      end

      it "フォーマットを指定できる" do
        expect(helper.format_time("2013-08-03 03:22:29 UTC",  "%Y/%m/%d")).to eq("2013/08/03")
      end
    end

    context "文字列以外のオブジェクト" do
      subject { helper.format_time(Time.new(2013, 8, 7, 15, 30, 45).utc) }
      it "ローカル時刻に合わせてフォーマットされる" do
        expect(subject).to eq("2013-08-07 15:30:45")
      end
    end
  end
end

