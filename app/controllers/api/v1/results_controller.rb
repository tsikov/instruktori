module Api
  module V1
    class ResultsController < ApplicationController
      respond_to :json

      def index
        @page = result_params[:page].blank? ? 1 : result_params[:page].to_i
        query = Result.all
        query = query.where(instructor_id: result_params[:instructor_id]) if result_params[:instructor_id]
        @results_count = query.count
        @results = query.paginate(:page => @page)
      end

      def result_params
        params.slice(:page, :instructor_id)
      end

    end
  end
end


