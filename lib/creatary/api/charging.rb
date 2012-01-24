require 'json'
require 'creatary/user'
require 'creatary/error'

# Charging part of the Creatary REST API
module Creatary
  class API
    # Requests for charging or payment to the subscriber account in the operator billing system by amount.
    #
    # @return [Hash] 
    #   {"status"=>{"code"=>0, "message"=>"Request was handled succesfully"}}
    def self.charge_by_amount(user, amount)
      begin
        payload = JSON.generate({'method' => 'AMOUNT', 'amount' => amount.to_s})
        response = dispatch_to_server(:post, '/api/1/charge/request', user, payload)
        JSON.parse response
      rescue Creatary::ServiceUnavailable
        raise Creatary::ServiceUnavailable.new 'The charging service is not available. If you are using the service on a persona, i.e.: through the sandbox, then remember to set the balance of that persona'
      end
    end
    
    # Requests for charging or payment to the subscriber account in the operator billing system byt charging code.
    #
    # @return [Hash] 
    #   {"status"=>{"code"=>0, "message"=>"Request was handled succesfully"}}
    def self.charge_by_code(user, code)
      begin
        payload = JSON.generate({'method' => 'CODE', 'charging_code' => code.to_s})
        response = dispatch_to_server(:post, '/api/1/charge/request', user, payload)
        JSON.parse response
      rescue Creatary::ServiceUnavailable
        raise Creatary::ServiceUnavailable.new 'The charging service is not available. If you are using the service on a persona, i.e.: through the sandbox, then remember to set the balance of that persona'
      end
    end
  end
end