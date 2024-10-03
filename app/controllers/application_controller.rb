class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_sports
  protect_from_forgery with: :exception

  private

  def set_sports
    # Load all sports or handle cases where there might be none
    @sports = Sport.all
  end
end
