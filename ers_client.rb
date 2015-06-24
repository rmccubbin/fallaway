require './fallaway.rb'

client = LocalFallawayClient.new('./ers.rb')

client.post('/admin/clouds', {hello: 'bob'})

clouds = client.get('/clouds')
puts clouds.inspect
