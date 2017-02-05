require 'twitter'

class TwitterClient
    attr_accessor :handle, :count

    def initialize(handle, count)
        @handle = handle
        @count = count
    end

    def get_tweets
        unless @handle.nil?
            handle_errors do
                handle_caching(handle) do
                    @client = Twitter::REST::Client.new do |config|
                        config.consumer_key = ENV['TWITTER_CONSUMER_KEY_API']
                        config.consumer_secret = ENV['TWITTER_API_SECRET']
                        config.access_token = ENV['TWITTER_OAUTH_ACCESS_TOKEN']
                        config.access_token_secret = ENV['TWITTER_OAUTH_ACCESS_TOKEN_SECRET']
                    end

                    @client.user_timeline(handle.to_s, count: count)
                end
            end
      end
    end

    def handle_errors
        yield
    rescue Twitter::Error => error
        Rails.logger.error "Error: #{error}"
        {}
    end

    def cache_key(handle)
        "twitterclient:handle:#{handle}"
    end

    def handle_caching(handle)
        if cached = $redis.get(cache_key(handle))
            Rails.logger.info("Returning cached tweets for #{cache_key(handle)}")
            Rails.logger.info JSON.parse(cached)
            JSON.parse(cached)

        else
            yield.tap do |results|
                Rails.logger.info("Caching tweets for #{cache_key(handle)}")
                Rails.logger.info results.to_json
                $redis.set(cache_key(handle), results.to_json)
                $redis.expire(cache_key(handle), 5.minute.to_i)
                results.to_json
            end
        end
     end
end
