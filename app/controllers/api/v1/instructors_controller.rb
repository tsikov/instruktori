module Api
  module V1
    class InstructorsController < ApplicationController
      respond_to :json

      def index
        if params[:page].blank?
          @page = 1
        else
          @page = params[:page].to_i
        end
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

