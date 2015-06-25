require './ers.rb'

use Rack::ShowExceptions
run Fallaway.instance
