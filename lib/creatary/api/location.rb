require 'json'
require 'creatary/user'
require 'creatary/error'

# SMS part of the Creatary REST API
module Creatary
  class API
    # Find the location (coordinates) of a user
    #
    # @return [Hash] 
    #   {"body"=>
    #    {"latitude"=>51.618,
    #     "timestamp"=>1302185772456,
    #     "accuracy"=>100,
    #     "longitude"=>23.9063},
    #   "status"=>{"code"=>0, "message"=>"Request was handled succesfully"}}
    def self.getcoord(user)
      begin
        response = dispatch_to_server(:get, '/api/1/location/getcoord', user)
        JSON.parse response
      rescue Creatary::ServiceUnavailable
        raise Creatary::ServiceUnavailable.new 'The location service is not available. If you are using the service on a persona, i.e.: through the sandbox, then remember to set the location of the persona'
      end
    end
  end
end
