require 'twitter'

class TwitterClient
    def get_tweets(handle, count)
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

    def handle_errors
        yield
    rescue Twitter::Error::Forbidden => error
        Rails.logger.error "Invalid credentials: #{error}"
        {}
    rescue Net::OpenTimeout, Net::ReadTimeout
        Rails.logger.error 'Network error'
        {}
    end

    def cache_key(handle)
        "twitterclient:handle:#{handle}"
    end

    def handle_caching(handle)
        if cached = $redis.get(cache_key(handle))
            Rails.logger.info("Returning cached tweets for #{cache_key(handle)}")
            cached
        else
            yield.tap do |results|
                Rails.logger.info("Caching tweets for #{cache_key(handle)}")
                $redis.set(cache_key(handle), results)
            end
        end
     end
end
