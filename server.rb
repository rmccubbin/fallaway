require './fallaway.rb'

messages = [] 

get '/messages' do
  puts 'returning list of messages'
  messages
end

post '/admin/messages' do |params|
  puts "adding #{params.inspect}"
  messages << params
end
