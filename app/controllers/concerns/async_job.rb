module AsyncJob
  def schedule_photo_collect user
    user.access_tokens.not_expired.select(:id, :provider).each{|access_token|
      client_klass = Clients::Social.find_class(access_token.provider)
      Clients::Job.kick(PhotoCrawler, client_klass.to_s, access_token.id) if client_klass
    }
  end
end
