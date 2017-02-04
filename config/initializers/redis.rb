$redis = Redis::Namespace.new('twitter_explorer', redis: Redis.new(url: (ENV['REDIS_URL'] || 'redis://127.0.0.1:6379')))
