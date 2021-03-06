require_relative "../../config/directories"

module Crabgrass
end

#
# Do these early because they are needed early
# (e.g. environments/*.rb, lib/extends, and permissions.rb)
#
require_relative 'conf'
require_relative 'exceptions'

# load our core extends early, since they might be use anywhere.
# active_support needs to be required before this, so we get methods like alias_method_chain
Dir.glob(APP_ROOT + "lib/extends/*.rb").each do |file|
  require file
end

# load Crabgrass::Initializer early, it is used in environment.rb
#require File.dirname(__FILE__) + '/initializer'

# load configuration file
Conf.load("crabgrass.#{Rails.env}.yml")

begin
  Conf.secret = File.read(CRABGRASS_SECRET_FILE).chomp
rescue
  unless ARGV.first == "create_a_secret"
    raise "Can't load the secret key from file #{CRABGRASS_SECRET_FILE}. Have you run 'rake create_a_secret'?"
  end
end

