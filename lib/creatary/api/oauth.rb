require 'sinatra'
require 'oauth'
require 'creatary/error'
require 'creatary/user'

# OAUTH part of the Creatary REST API
module Creatary
  class API
    enable :sessions
    
    # Authorizes a user of Creatary to use your application
    # After the OAUTH flow is finished then the configured consumer_handler.authorized(user, session)
    # or consumer_handler.denied(session) are invoked
    get '/*/authorize' do
      consumer = Creatary::API.create_oauth_consumer
      request_token = consumer.get_request_token
      session[:request_token] = request_token
      
      oauth_callback_url = url('/' + Creatary.callback_path + '/oauth_callback')
      if params[:subscription_tariff_name].nil?
        redirect request_token.authorize_url(:oauth_callback => oauth_callback_url)
      else
        redirect request_token.authorize_url(:oauth_callback => oauth_callback_url, :subscription_tariff_name => params[:subscription_tariff_name])
      end
    end
    
    # OAUTH callback for Creatary
    # @private
    get '/*/oauth_callback' do
      if params[:denied].nil?
        consumer = Creatary::API.create_oauth_consumer
        request_token = session[:request_token]
        verifier = params[:oauth_verifier]
        access_token = request_token.get_access_token(:oauth_verifier => verifier)
        user = User.new(access_token.token, access_token.secret)
        if params[:subscription_tariff_name].nil?
          redirect url(dispatch_to_handler('authorized', user, session))
        else
          redirect url(dispatch_to_handler('authorized', user, session, params[:subscription_tariff_name]))
        end
      else
        redirect url(dispatch_to_handler('denied', session))
      end
    end
    
    private
    def self.create_oauth_consumer
      if Creatary.consumer_key.nil? or Creatary.consumer_secret.nil?
        raise OAuthConsumerAttributesMissing.new
      end
      
      OAuth::Consumer.new(Creatary.consumer_key, Creatary.consumer_secret,
        {
          :site => Creatary.site,
          :request_token_path => Creatary.request_token_path,
          :access_token_path => Creatary.access_token_path,  
          :authorize_path => Creatary.authorize_path, 
          :scheme => Creatary.oauth_scheme,
          :http_method => Creatary.oauth_http_method
        })
    end
  end
end