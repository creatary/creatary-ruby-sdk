#
# Copyright 2012 Nokia Siemens Networks 
#
require 'creatary/railtie' if defined? ::Rails::Railtie
require 'creatary/configuration'
require 'creatary/api'

module Creatary
  extend Configuration

  # If in rails environment then we use the rails default logger
  # otherwise we create one that points to the standard output
  LOGGER = 
    if defined? Rails 
      Rails.logger
    else
      require 'logger'
      Logger.new(STDOUT)
    end

end
