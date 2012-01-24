module Creatary
  # Represents an end-user of Creatary (a subscriber)
  class User
    attr_accessor :access_token
    attr_accessor :token_secret
    
    def initialize(access_token, token_secret)
      @access_token = access_token
      @token_secret = token_secret
    end
    
    def ==(another_user)
        self.access_token == another_user.access_token and self.token_secret == another_user.token_secret
    end
  end
end