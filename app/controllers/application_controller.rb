class ApplicationController < ActionController::Base
  def index
    render json: {message: "Hello there!"}, status: :ok
  end

  def not_found
    render json: {errors: "not found"}, status: :not_found
  end
end
