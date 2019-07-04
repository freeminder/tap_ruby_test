class ApplicationController < ActionController::Base
  def index
    respond_to do |format|
      format.any { render html: "Hello there!" }
    end 
  end
end
