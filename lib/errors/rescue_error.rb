module Errors
  module RescueError

    def self.included(base)
      base.rescue_from Errors::UnprocessableEntity do |e|
        render json: {errors: [e.message]}, status: 422
      end

      base.rescue_from Errors::InternalServerError do |e|
        render :nothing, status: 500
      end
    end

  end
end