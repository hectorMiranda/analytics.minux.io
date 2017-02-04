class ExplorerController < ApplicationController
    def index
        @results = Explorer.search(params[:search]) if params[:search]
    end
end
