require './server.rb'

use Rack::ShowExceptions
run Fallaway.instance
