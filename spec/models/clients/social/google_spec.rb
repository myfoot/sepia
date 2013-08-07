# -*- coding: utf-8 -*-
require 'erb'
require 'spec_helper'
require 'nokogiri'

xml_template = <<XML
<?xml version='1.0' encoding='UTF-8'?>
<feed xmlns='http://www.w3.org/2005/Atom' xmlns:gphoto='http://schemas.google.com/photos/2007' xmlns:media='http://search.yahoo.com/mrss/' xmlns:openSearch='http://a9.com/-/spec/opensearchrss/1.0/'>
  <id>https://picasaweb.google.com/data/feed/api/user/110591772917304487723</id>
  <updated>2013-07-22T08:51:17.507Z</updated>
  <category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#user'/>
  <title type='text'>110591772917304487723</title>
  <subtitle type='text'/>
  <icon>https://lh6.googleusercontent.com/-qvw2Pd36rHE/AAAAAAAAAAI/AAAAAAAAAAA/qlL59ZlbALM/s64-c/110591772917304487723.jpg</icon>
  <link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='https://picasaweb.google.com/data/feed/api/user/110591772917304487723'/>
  <link rel='alternate' type='text/html' href='https://picasaweb.google.com/110591772917304487723'/>
  <link rel='http://schemas.google.com/photos/2007#slideshow' type='application/x-shockwave-flash' href='https://static.googleusercontent.com/external_content/picasaweb.googleusercontent.com/slideshow.swf?host=picasaweb.google.com&amp;RGB=0x000000&amp;feed=https://picasaweb.google.com/data/feed/api/user/110591772917304487723?alt%3Drss'/>
  <link rel='self' type='application/atom+xml' href='https://picasaweb.google.com/data/feed/api/user/110591772917304487723?q=&amp;start-index=1&amp;max-results=1&amp;kind=photo'/>
  <link rel='next' type='application/atom+xml' href='https://picasaweb.google.com/data/feed/api/user/110591772917304487723?q=&amp;start-index=2&amp;max-results=1&amp;kind=photo'/>
  <author>
    <name>natsuki yagi</name>
    <uri>https://picasaweb.google.com/110591772917304487723</uri>
  </author>
  <generator version='1.00' uri='http://picasaweb.google.com/'>Picasaweb</generator>
  <openSearch:totalResults>1414</openSearch:totalResults>
  <openSearch:startIndex>1</openSearch:startIndex>
  <openSearch:itemsPerPage>1</openSearch:itemsPerPage>
  <gphoto:user>110591772917304487723</gphoto:user>
  <gphoto:nickname>natsuki yagi</gphoto:nickname>
  <gphoto:thumbnail>https://lh6.googleusercontent.com/-qvw2Pd36rHE/AAAAAAAAAAI/AAAAAAAAAAA/qlL59ZlbALM/s64-c/110591772917304487723.jpg</gphoto:thumbnail>
  <gphoto:quotalimit>16106127360</gphoto:quotalimit>
  <gphoto:quotacurrent>412588851</gphoto:quotacurrent>
  <gphoto:maxPhotosPerAlbum>1000</gphoto:maxPhotosPerAlbum>
  <entry>
    <id>https://picasaweb.google.com/data/entry/api/user/110591772917304487723/albumid/5894694544041466033/photoid/5894697306078595682</id>
    <published><%= ymd %>T00:36:07.000Z</published>
    <updated>2013-06-29T00:36:08.999Z</updated>
    <category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#photo'/>
    <title type='text'>IMG_0839.JPG</title>
    <summary type='text'/>
    <content type='image/jpeg' src='https://lh6.googleusercontent.com/-CoTtERJoUys/Uc4r9-tESmI/AAAAAAAADi4/qDTvUpdvNAs/IMG_0839.JPG'/>
    <link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='https://picasaweb.google.com/data/feed/api/user/110591772917304487723/albumid/5894694544041466033/photoid/5894697306078595682?authkey=dbfRRkewXl8'/>
    <link rel='alternate' type='text/html' href='https://picasaweb.google.com/110591772917304487723/12?authkey=dbfRRkewXl8#5894697306078595682'/>
    <link rel='http://schemas.google.com/photos/2007#canonical' type='text/html' href='https://picasaweb.google.com/lh/photo/pFGvGusYqmkgikHO9hHCa9MTjNZETYmyPJy0liipFm0'/>
    <link rel='self' type='application/atom+xml' href='https://picasaweb.google.com/data/entry/api/user/110591772917304487723/albumid/5894694544041466033/photoid/5894697306078595682?authkey=dbfRRkewXl8'/>
    <link rel='edit' type='application/atom+xml' href='https://picasaweb.google.com/data/entry/api/user/110591772917304487723/albumid/5894694544041466033/photoid/5894697306078595682/3630?authkey=dbfRRkewXl8'/>
    <link rel='edit-media' type='image/jpeg' href='https://picasaweb.google.com/data/media/api/user/110591772917304487723/albumid/5894694544041466033/photoid/5894697306078595682/3630?authkey=dbfRRkewXl8'/>
    <link rel='media-edit' type='image/jpeg' href='https://picasaweb.google.com/data/media/api/user/110591772917304487723/albumid/5894694544041466033/photoid/5894697306078595682/3630?authkey=dbfRRkewXl8'/>
    <link rel='http://schemas.google.com/photos/2007#report' type='text/html' href='https://picasaweb.google.com/lh/reportAbuse?uname=110591772917304487723&amp;aid=5894694544041466033&amp;iid=5894697306078595682'/>
    <gphoto:id>5894697306078595682</gphoto:id>
    <gphoto:version>3630</gphoto:version>
    <gphoto:albumid>5894694544041466033</gphoto:albumid>
    <gphoto:access>private</gphoto:access>
    <gphoto:width>1536</gphoto:width>
    <gphoto:height>2048</gphoto:height>
    <gphoto:size>899651</gphoto:size>
    <gphoto:client/>
    <gphoto:checksum/>
    <gphoto:timestamp>1369535162000</gphoto:timestamp>
    <gphoto:imageVersion>3630</gphoto:imageVersion>
    <gphoto:commentingEnabled>true</gphoto:commentingEnabled>
    <gphoto:commentCount>0</gphoto:commentCount>
    <media:group>
      <media:content url='https://lh6.googleusercontent.com/-CoTtERJoUys/Uc4r9-tESmI/AAAAAAAADi4/qDTvUpdvNAs/IMG_0839.JPG' height='512' width='384' type='image/jpeg' medium='image'/>
      <media:credit>natsuki yagi</media:credit>
      <media:description type='plain'/>
      <media:keywords/>
      <media:thumbnail url='https://lh6.googleusercontent.com/-CoTtERJoUys/Uc4r9-tESmI/AAAAAAAADi4/qDTvUpdvNAs/s72/IMG_0839.JPG' height='72' width='54'/>
      <media:thumbnail url='https://lh6.googleusercontent.com/-CoTtERJoUys/Uc4r9-tESmI/AAAAAAAADi4/qDTvUpdvNAs/s144/IMG_0839.JPG' height='144' width='108'/>
      <media:thumbnail url='https://lh6.googleusercontent.com/-CoTtERJoUys/Uc4r9-tESmI/AAAAAAAADi4/qDTvUpdvNAs/s288/IMG_0839.JPG' height='288' width='216'/>
      <media:title type='plain'>IMG_0839.JPG</media:title>
    </media:group>
  </entry>
</feed>
XML

describe Clients::Social::Google do
  let(:token) { AccessToken.new(name: "user_name", token: "hoge", refresh_token: "ref-hoge") }
  let(:client) { Clients::Social::Google.new(token) }
  let(:max_result) {
    date = Time.parse('2013-05-31');
    Clients::Social::Google::MAX_PER_PAGE.times.map{|i|
      date -= 1.day
      ymd = date.strftime("%Y-%m-%d")
      Clients::Social::GooglePhoto.new(Nokogiri::XML(ERB.new(xml_template).result(binding)).xpath('//xmlns:entry').first)
    }
  }
  let(:few_result) {
    date = Time.parse('2013-05-31');
    (Clients::Social::Google::MAX_PER_PAGE * 0.1).to_i.times.map{|i|
      date -= 1.day
      ymd = date.strftime("%Y-%m-%d")
      Clients::Social::GooglePhoto.new(Nokogiri::XML(ERB.new(xml_template).result(binding)).xpath('//xmlns:entry').first)
    }
  }
  
  describe "#photos" do
    context "データが無い場合" do
      subject { client.photos }
      before do
        client.stub(:page_data).and_return([])
      end
      it "空配列" do
        expect(subject).to match_array([])
      end
    end

    context "データが存在する場合" do

      describe "戻り値の型" do
        subject { client.photos.first }
        before do
          client.should_receive(:page_data).once.and_return(few_result)
        end
        it "Photo::Googleのオブジェクトを返す" do
          expect(subject).to be_a(Photo::Google)
        end
      end

      context "日付指定なしの場合" do
        subject { client.photos }
        before do
          client.should_receive(:page_data).once.and_return(max_result)
          client.should_receive(:page_data).once.and_return(few_result)
        end
        it "全データを取得する" do
          expect(subject.size).to eq(max_result.size + few_result.size)
          expect(subject.last.platform_id).to eq(few_result.last.id)
        end
      end

      context "日付指定ありの場合" do
        subject { client.photos Time.parse("2013-05-29 14:10:57 UTC") }
        before do
          client.should_receive(:page_data).once.and_return(max_result)
        end
        it "指定した日付より後のデータを取得する" do
          expect(subject.size).to eq(1)
          expect(subject.last.platform_id).to eq(max_result[0].id)
        end
      end

      context "ページ指定あり場合" do
        before do
          client.should_receive(:page_data).with(Clients::Social::Google::MAX_PER_PAGE).once.and_return(few_result)
        end
        it "指定ページ以降のデータを取得する" do
          client.photos nil, 2
        end
      end
    end
  end
end
