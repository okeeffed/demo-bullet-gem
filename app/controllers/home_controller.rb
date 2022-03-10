class HomeController < ApplicationController
  def index
    @users = User.includes(:documents).all
  end
end
