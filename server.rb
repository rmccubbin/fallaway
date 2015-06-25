require './fallaway.rb'

clouds = [] 

get '/messages' do
  puts 'returning list of messages'
  clouds
end

post '/admin/messages' do |params|
  puts "adding #{params.inspect}"
  clouds << params
end
