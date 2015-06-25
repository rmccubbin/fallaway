require './fallaway.rb'
require './usage.rb'

using_local, host = usage()

if using_local
  client = FallawayClient.new_client({file: './server.rb'})
else
  client = FallawayClient.new_client({url: host})
end

client.post('/admin/messages', {hello: 'bob'})

messages = client.get('/messages')
puts messages.inspect
