module Api
  module V1
    class InstructorsController < ApplicationController
      respond_to :json

      def index
        @instructors = Instructor.paginate(:page => params[:page])
      end

    end
  end
end

