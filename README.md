# Fallaway

The purpose of the fallaway library is as a POC for creating a library which allows you to write internal services as if they were a seperate microservice. So you can use the idioms of a restful server or client within your application code while having the implementation fallaway to being simple method calls if service is running in the same process. It also provides the option to do the opposite and split that service out to a fullblown microservice simply by reconfiguring the client.

## Intention

Inspired by an article which I can no longer find which proposed that while in theory carving up a monolithic code base into micro services should be easy if you have nicely written code. In reality it tends to be very difficult because you share object representations, abstractions, interfaces and dependencies all over the code base even though it may be well written easy to understand code. Unpicking those things can become very difficult.

The thought was well maybe instead of using dependency inject etc. in our code which usually does not actually prevent that type of issue. We should within a single code base simple write our components as if they were running in a microservice with nothing shared. Kindof bringing the inconvience of a micros service within your application ;-). However instead of being subject to the deployment, monitoring and performance overheads of creating a new microservice a library would allow the all the http calls to **fall away** and return to method calls if the service was in the same process.

## Usage

Fallaway is designed to have two mode **Local** and **HTTP**. Local mode performs method calls on a fallaway server. Http mode runs the server as an http server and the client makes http requests just like a regular microservice.

### Local Mode
In local mode you can pass in a file which provides a fallaway server. When you make calls to the fallaway client in localmode they will get transformed into direct method calls on the fallaway server.

### Http Mode
In http mode we use rack to run your fallaway server as an http server and you must provide a config.ru file to tell rack how to setup your server. You can then run the server using:
```bash
$ rackup config.ru
# or in our poc case
$ rackup ers.ru
```

The client should be given the host address of the server you just started to send requests to.


## Show me the code!!!

This POC is heavily inspired by the Sinatra and RestClient gems and emulates their apis.

### Client

```ruby
require './fallaway.rb'
require './usage.rb'

using_local, host = usage()

if using_local
  # Run in local mode where the service is provided by a file and run in the same process
  client = FallawayClient.new_client({file: './ers.rb'})
else
  # Run in http mode where the service is provided by a full microservice 
  # running at a given host
  client = FallawayClient.new_client({url: host})
end

client.post('/admin/clouds', {hello: 'bob'})

clouds = client.get('/clouds')
puts clouds.inspect
```

### Server

```ruby
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
```

## Running the POC

The POC can be run in either Local or HTTP mode
First you will need to install the dependencies
```bash
bundle install
```

### Local Example
```bash
$ bundle exec ruby ers_client.rb local
```

### Http Example
```bash
$ bundle exec rackup ers.ru # run the server will be running on http://localhost:9292/clouds

# in another terminal
$ bundle exec ruby ers_client.rb http http://localhost:9292
```
