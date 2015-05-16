module Api
  module V1
    class InstructorsController < ApplicationController
      respond_to :json

      def index

        @page = params[:page].blank? ? 1 : params[:page].to_i
        @city = params[:city].blank? ? "all" : params[:city]
        @category = params[:category].blank? ? "all" : params[:category]

        query = Instructor.all
        query = query.where(city: @city) if @city != "all"
        query = query.where("categories @> ?", "{#{@category}}") if @category != "all"

        @instructors_count = query.count
        @instructors = query.paginate(page: @page)
      end

      def show
        @instructor = Instructor.find(params[:id])
      end

      def cities
        render json: Instructor.select("DISTINCT city").map(&:city).compact
      end

      def categories
        render json: Instructor.select('unnest(categories) AS categories').pluck(:categories).flatten.uniq
      end

    end
  end
end

# TODO whitelist


