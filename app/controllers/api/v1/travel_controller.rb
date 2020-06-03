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


  def events 
    eventNames = []
    events = []
    count = 0
    key = ENV["TICKETMASTER_KEY"]
    size = 50
    sort = "date,name"
    city = params["city"].split(",")[0]
    state = params["city"].gsub(" ", "").split(",")[1]
    response = RestClient::Request.execute(
      method: "GET",
      url: "https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{key}&size=#{size}&city=#{city}&state_code=#{state}",  
      headers: { }  
    )    
    data = JSON.parse(response)

    if data["_embedded"]

      data["_embedded"]["events"].each do |e|

        if !eventNames.include? e["name"]
          eventNames.push(e["name"])

          sleep(0.2)
          response = RestClient::Request.execute(
            method: "GET",
            url: "https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{key}&id=#{e["id"]}",  
            headers: { }  
          )    
          data = JSON.parse(response)
          events.push(data)
          count += 1
          break if count > 15
        end
      end
    end
    render json: events
  end
end