#
# Copyright 2012 Nokia Siemens Networks 
#
require 'spec_helper'
require 'creatary/api'
require 'creatary/user'
require 'rack/test'
require 'mocha'
require 'json'

describe Creatary::API, "when receiving sms" do
  include Rack::Test::Methods

  def app
    Creatary::API
  end
  
  before(:all) do
    logger = stub('logger')
    logger.stubs(:error)
    Creatary.const_set(:LOGGER, logger)
  end
  
  it "should pass request to creatary sms handler and render success" do
    #given
    handler = stub('consumer_handler')
    handler.expects(:respond_to?).with('receive_sms').returns(true)
    handler.expects(:send).with('receive_sms', Creatary::User.new('token', 'secret'), 'to_app', 'message', nil)
    Creatary.expects(:consumer_handler).times(3).returns(handler)
    #when
    post '/creatary/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user' ,'access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_ok
  end
  
  it "should pass request with transaction to creatary sms handler and render success" do
    #given
    handler = stub('consumer_handler')
    handler.expects(:respond_to?).with('receive_sms').returns(true)
    handler.expects(:send).with('receive_sms', Creatary::User.new('token', 'secret'), 'to_app', 'message', 'tran_id')
    Creatary.expects(:consumer_handler).times(3).returns(handler)
    #when
    post '/creatary/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user','transaction_id' => 'tran_id','access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_ok
  end
  
  it "should pass request to creatary sms handler and render error on unexpected error" do
    #given
    handler = stub('consumer_handler')
    handler.expects(:respond_to?).with('receive_sms').returns(true)
    handler.stubs(:send).raises(Creatary::UnexpectedError.new("Cannot handle"))
    Creatary.expects(:consumer_handler).times(3).returns(handler)
    #when
    post '/creatary/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user','transaction_id' => 'tran_id','access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_server_error
    last_response.body.should == "Cannot handle"
  end
  
  it "should pass request to creatary sms handler and render error on missing consumer_handler" do
    #given
    handler = stub('consumer_handler')
    Creatary.expects(:consumer_handler).times(1).returns(nil)
    #when
    post '/creatary/receive_sms', JSON.generate({ 'body' => 'message', 'to' => 'to_app', 'from' => 'from_user','transaction_id' => 'tran_id','access_token' => 'token', 'token_secret' => 'secret'})
    #then
    last_response.should be_server_error
    last_response.body.should == "Application has not configured the Creatary consumer_handler"
  end
end