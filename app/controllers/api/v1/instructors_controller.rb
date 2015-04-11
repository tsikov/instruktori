module Api
  module V1
    class InstructorsController < ApplicationController
      respond_to :json

      def index
        @page = params[:page].blank? ? 1 : params[:page].to_i
        query = Instructor.all
        @instructors_count = query.count
        @instructors = query.paginate(:page => @page)
      end

      def show
        @instructor = Instructor.find(params[:id])
      end

    end
  end
end

# TODO whitelist


