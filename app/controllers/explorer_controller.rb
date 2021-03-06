class ExplorerController < ApplicationController
    before_action :load_tweets
    def load_tweets
        @tweets = if !params[:search].blank?
                      Explorer.get_tweets(params[:search])
                  else
                      []
                  end
    end

    def index; end
end
