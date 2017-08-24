module Errors
  module RescueError

    def self.included(base)
      base.rescue_from Errors::UnprocessableEntity do |e|
        render json: {errors: [e.message]}, status: 422
      end
    end

  end
end