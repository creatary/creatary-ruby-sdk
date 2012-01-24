require 'spec_helper'
require 'creatary/api'
require 'creatary/user'
require 'rack/test'
require 'json'
require 'webmock/rspec'

describe Creatary::API, "#getcoord" do
  include WebMock::API
  include OAuthSettings
  
  it "sends location request to platform" do
    #given
    Creatary.expects(:consumer_key).twice().returns(ConsumerKey)
    Creatary.expects(:consumer_secret).twice().returns(ConsumerSecret)
    Creatary.expects(:site).returns(Site)
    Creatary.expects(:request_token_path).returns('/api/1/oauth/request_token')
    Creatary.expects(:access_token_path).returns('/api/1/oauth/access_token')
    Creatary.expects(:authorize_path).returns('/web/authorize')
    Creatary.expects(:oauth_scheme).returns(:query_string)
    Creatary.expects(:oauth_http_method).returns(:get)
    http_stub = stub_request(:get, /.*\/api\/1\/location\/getcoord.*/).with { |request| assert_query(request.uri, OAuthParams) }.to_return(:body => load_fixture("getcoord_success.json"))
                  
    #when
    body = Creatary::API.getcoord(Creatary::User.new(AccessToken, AccessSecret))
    
    #then
    http_stub.should have_been_requested.times(1)
    body["status"]["code"].should == 0
    body["status"]["message"].should == "Message sent successfully"
  end
    
  def load_fixture(fixture)
    IO.read("spec/fixtures/#{fixture}")
  end
  
  def assert_query(uri, params)
    uri_params = uri.query_values
    params.each do |key, value| 
      if not value.match(uri_params[key])
        return false
      end
    end
    return true
  end
end