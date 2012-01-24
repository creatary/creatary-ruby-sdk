require 'rails'

module Creatary
  class CreataryRailtie < Rails::Railtie
    initializer "creatary.boot" do
      configure_with_yaml
    end
    
    private
    
    # Attempts to load the Creatary configuration from config/creatary.yml
    # in a rails 3 application.
    # Besides using a creatary.yml, developers can also configure directly Creatary settings, e.g.:
    # Creatary.consumer_key = 'h42woy35tl08o44l'
    def configure_with_yaml
      cfg = load_config(Rails.root.join('config', 'creatary.yml')).freeze
      Creatary.configure(cfg)
    end
    
    def load_config(yaml_file)
      return {} unless File.exist?(yaml_file)
      cfg = YAML::load(File.open(yaml_file))
      if defined? Rails
        cfg = cfg[Rails.env]
      end
      cfg
    end
    
  end
end