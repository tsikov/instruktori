module Api
  module V1
    class InstructorsController < ApplicationController
      respond_to :json

      def index

        @page = instructor_params[:page].blank? ? 1 : instructor_params[:page].to_i
        @city = instructor_params[:city].blank? ? "all" : instructor_params[:city]
        @category = instructor_params[:category].blank? ? "all" : instructor_params[:category]
        @order = instructor_params[:scoreOrder].blank? ? "DESC" : instructor_params[:scoreOrder]

        query = Instructor.all
        query = query.where(city: @city) if @city != "all"
        query = query.where("categories @> ?", "{#{@category}}") if @category != "all"
        query = query.text_search(instructor_params[:instructorName])

        query = query.order("score #{@order}")

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

      def instructor_params
        params.slice(:id, :page, :city, :category, :scoreOrder, :instructorName)
      end

    end
  end
end


