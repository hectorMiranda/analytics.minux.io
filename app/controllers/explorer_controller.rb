class ExplorerController < ApplicationController
    before_filter :load_tweets
    def load_tweets
        @tweets = if params[:search]
                      Explorer.get_tweets(params[:search])
                  else
                      []
                  end
    end

    def index; end
end
