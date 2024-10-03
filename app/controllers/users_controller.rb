class UsersController < ApplicationController
  def set_timezone
    session[:timezone] = params[:timezone]
    head :ok
  end
end
