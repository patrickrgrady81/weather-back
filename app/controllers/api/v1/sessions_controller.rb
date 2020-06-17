if Rails.env.development?
  require 'pry'
end

class API::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(email: params["user"]["email"]).try(:authenticate, params["user"]["password"])
    if user 
      session[:user_id] = user.id
      render json: {logged_in: true, user: user}
    else 
      render json: {status: 401}
    end
  end
end
