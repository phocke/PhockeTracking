class HomeController < ApplicationController
  def index
    @users = User.all
    @result = Result.new
  end
end
