require './fallaway.rb'

clouds = [] 

get '/clouds' do
  puts 'returning list of clouds'
  clouds
end

post '/admin/clouds' do |params|
  puts "adding #{params.inspect}"
  clouds << params
end
