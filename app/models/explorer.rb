class Explorer
    def self.get_tweets(handle, count = 25)
        TwitterClient.new(handle, count).get_tweets
    end
end
