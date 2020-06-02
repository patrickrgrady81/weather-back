if Rails.env.development?
  require 'pry'
end

class API::V1::TravelController < ApplicationController
  skip_before_action :verify_authenticity_token
  def restaurants
    city = params["travel"]["city"]
    response = RestClient::Request.execute(
      method: "GET",
      url: "https://api.yelp.com/v3/businesses/search",  
      headers: { Authorization: "Bearer #{ENV["YELP_KEY"]}", 
                  params: {
                    location: "#{city}",
                    categories: 'restaurant',
                    locale: 'en_US',
                    sort_by: 'rating',
                    limit: 10
                  }
      }  
    )    
    data = JSON.parse(response)
    # binding.pry

    businesses = data["businesses"].collect do |business|
      response = RestClient::Request.execute(
        method: "GET",
        url: "https://api.yelp.com/v3/businesses/#{business["id"]}",  
        headers: { Authorization: "Bearer #{ENV["YELP_KEY"]}", 
                    params: {
                      locale: 'en_US'
                    }
        }  
      )    
      data = JSON.parse(response)
    end



    render json: businesses 
  end
end