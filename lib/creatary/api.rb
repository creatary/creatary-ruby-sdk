require 'sinatra'
require 'oauth'
require 'creatary/error'
require 'creatary/user'

module Creatary
  # Wrapper for the Creatary REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {https://creatary.com the Creatary API Documentation}.
  # @see http://creatary.com
  class API < Sinatra::Base
    # Require api method modules after initializing the API class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # API-namespaced.
    require 'creatary/api/oauth'
    require 'creatary/api/sms'
    require 'creatary/api/location'
    require 'creatary/api/charging'
    require 'creatary/api/lifecycle'
    
    # Dispatches the request to the Creatary handler configured by 
    # this gem client
    def dispatch_to_handler(method, *args)
      if Creatary.consumer_handler.nil?
        LOGGER.error 'Application has not configured the Creatary consumer_handler'
        raise InvalidConsumerHandler.new 'Application has not configured the Creatary consumer_handler'
      end
      
      if Creatary.consumer_handler.respond_to?(method)
        begin
          return Creatary.consumer_handler.send(method, *args)
        rescue Creatary::Error => error
          LOGGER.error 'Application has suffered an internal error: ' + error.message + ', ' + error.body
          raise error
        end
      end
      
    end
    
    # Dispatches the request to the Creatary REST API
    def self.dispatch_to_server(http_method, endpoint, user, payload='')
      consumer = create_oauth_consumer
      access_token = OAuth::AccessToken.new(consumer, user.access_token, user.token_secret)

      if (http_method == :get)
        response = access_token.send(http_method, endpoint, {'Content-Type' => 'application/json'})
      else
        response = access_token.send(http_method, endpoint, payload, {'Content-Type' => 'application/json'})
      end
      
      if response.class == Net::HTTPOK
        return response.body
      elsif response.class == Net::HTTPUnauthorized
        LOGGER.error 'Request not authorized ' + response.message + ', ' + response.body
        raise RequestNotAuthorized.new(response.message, response.body)
      elsif response.class == Net::HTTPBadRequest
        if response.body.include? 'consumer_key_unknown'
          LOGGER.error 'Configured Creatary consumer_key is not valid: ' + response.message + ', ' + response.body
          raise InvalidConsumerKey.new(response.message, response.body)
        elsif response.body.include? 'signature_invalid'
          LOGGER.error 'Configured Creatary consumer_secret is not valid: ' + response.message + ', ' + response.body
          raise InvalidConsumerSecret.new(response.message, response.body)
        else
          raise UnexpectedError.new(response.message, response.body)
        end
      elsif response.class == Net::HTTPServiceUnavailable
        LOGGER.error 'Creatary service ' + endpoint + ' not available'
        raise ServiceUnavailable.new(response.message, response.body)
      else
        raise UnexpectedError.new(response.message, response.body)
      end
    end
    
  end
end
