# if Rails.env.development?
#   require 'pry'
# end

class API::V1::TravelController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    test = {test: true}
    render json: test
  end
end