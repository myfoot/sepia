# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clients::Job do
  let(:user) { User.save(name: 'test') }
  let(:client_klass_name) { 'hoge' }
  let(:access_token_id) { 1 }

  describe "kick" do
    context "キャッシュがない場合" do
      before do
        time_travel_to "1 years ago" # 1年前という日付に特に意味は無い
      end
      after do
        Sidekiq::Queue.new.each{|job| job.delete }
        Rails.cache.clear
      end

      context "同一ジョブが存在しない場合" do
        it "ジョブを登録する" do
          PhotoCrawler.should_receive(:perform_async).with(client_klass_name, access_token_id)
          Clients::Job.kick(PhotoCrawler, client_klass_name, access_token_id)
        end
      end

      context "同一ジョブが存在する場合" do
        before do
          PhotoCrawler.perform_async(client_klass_name, access_token_id)
        end

        it "ジョブを登録しない" do
          PhotoCrawler.should_not_receive(:perform_async).with(client_klass_name, access_token_id)
          Clients::Job.kick(PhotoCrawler, client_klass_name, access_token_id)
        end
      end

      it "キャッシュを作る" do
        Clients::Job.kick(PhotoCrawler, client_klass_name, access_token_id)
        expect(Rails.cache.read(Clients::Job.send(:cache_key, PhotoCrawler, client_klass_name, access_token_id))).to eq(Time.now.to_i)
      end
    end

    context "キャッシュがある場合" do
      before do
        @key = Clients::Job.send(:cache_key, PhotoCrawler, client_klass_name, access_token_id)
        Rails.cache.write(@key, Time.now.to_i, expires_in: 1.minute)
      end
      after do 
        Rails.cache.delete(@key)
      end

      it "ジョブを登録しない" do
          PhotoCrawler.should_not_receive(:perform_async).with(client_klass_name, access_token_id)
          Clients::Job.kick(PhotoCrawler, client_klass_name, access_token_id)
      end
    end
  end
end
