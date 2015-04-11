module Api
  module V1
    class ResultsController < ApplicationController
      respond_to :json

      def index
        @page = params[:page].blank? ? 1 : params[:page].to_i
        query = Result.all
        query = query.where(instructor_id: params[:instructor_id]) if params[:instructor_id]
        @results_count = query.count
        @results = query.paginate(:page => @page)
      end

      #def show
        #@result = Result.find(params[:id])
      #end

    end
  end
end

# TODO whitelist


