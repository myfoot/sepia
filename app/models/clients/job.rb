# -*- coding: utf-8 -*-
class Clients::Job
  class Queues
    def initialize
      @queues = Sidekiq::Queue.new
    end
    def not_exist? *args
      !@queues.any? {|queue| args == queue.args }
    end
  end

  @@queues = Queues.new

  class << self
    def kick job_klass, *args
      key = cache_key(job_klass, *args)
      Rails.cache.fetch(key, expires_in: 1.minute) do
        job_klass.perform_async(*args) if @@queues.not_exist?(*args)
        Time.now.to_i
      end
    end

    private
    def cache_key job_klass, *args
      args.unshift(job_klass).map{|item| item.to_s }.join('::')
    end
  end
end
