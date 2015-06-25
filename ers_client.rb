require './fallaway.rb'
require './usage.rb'

using_local, host = usage()

if using_local
  client = FallawayClient.new_client({file: './ers.rb'})
else
  client = FallawayClient.new_client({url: host})
end

client.post('/admin/clouds', {hello: 'bob'})

clouds = client.get('/clouds')
puts clouds.inspect
