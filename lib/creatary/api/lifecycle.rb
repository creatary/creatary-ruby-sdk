require 'sinatra'
require 'oauth'
require 'json'
require 'creatary/user'

# Lifecycle part of the Creatary REST API
module Creatary
  class API
    # URL handler for receiving lifecycle notifications
    # After receiving a lifecycle notification, the configured 
    # consumer_handler.lifecycle_notification(channel, invoker, reason, 
    # applicationName, notificationType, accessTokens)
    # is invoked
    #
    # @private
    post "/*/lifecycle_callback" do
      request.body.rewind # in case someone already read it

      data = JSON.parse request.body.read

      channel = data["channel"]
      invoker = data["invoker"]
      reason = data["reason"]
      application_name = data["applicationName"]
      notification_type = data["notificationType"]
      access_tokens = data["accessTokens"]

      begin
        dispatch_to_handler('lifecycle_notification', channel, invoker, reason, application_name, notification_type, access_tokens)
        response.status = 200
        return ''
      rescue Error => error
        response.status = 500
        return error.message
      end
    end
    
    # Unregisters a user
    # @return [Hash] 
    #   {"status"=>{"code"=>0, "message"=>"Request was handled succesfully"}}
    def self.unregister(user)
      puts "here1"
      response = dispatch_to_server(:delete, '/api/1/subscriberlifecycle/unsubscribe', user)
      puts "here2"
      JSON.parse response
    end
    
  end
end