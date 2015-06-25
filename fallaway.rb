require 'rack/request'
require 'rack/response'
require 'restclient'
require 'json'

class Fallaway

  attr :fallaway 
  attr :get_apis
  attr :post_apis
  attr :put_apis
  attr :delete_apis

  def initialize
    @get_apis = {}
    @post_apis = {}
    @put_apis = {}
    @delete_apis = {}
  end

  def self.instance
    if @fallaway.nil?
      @fallaway = Fallaway.new
    end
    @fallaway 
  end
  
  def get(path)
    @get_apis[path].call
  end

  def post(path, object)
    @post_apis[path].call(object)
  end

  def put(path, object)
    @put_apis[path].call(object)
  end

  def delete(path)
    @delete_apis[path].call
  end

  def register_get(path, block)
    @get_apis[path] = block
  end

  def register_post(path, block)
    @post_apis[path] = block
  end

  def register_put(path, block)
    @put_apis[path] = block
  end

  def register_delete(path, block)
    @delete_apis[path] = block
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.get?
      response_object = get(req.path)
      return_as_json_response(response_object)
    elsif req.post?
      response_object = post(req.path, JSON.parse(req.body.read()))
      return_as_json_response(response_object)
    elsif req.put?
      response_object = put(req.path, req.params)
      return_as_json_response(response_object)
    elsif req.delete?
      response_object = delete(req.path)
      return_as_json_response(response_object)
    end
  end

  def return_as_json_response(response_object)
    res = Rack::Response.new
    if response_object
      response_json = JSON.generate(response_object)
      res.write response_json
    end
    res.finish
  end

end

def get(path, &block)
  Fallaway.instance.register_get(path, block)
end

def put(path, &block) 
  Fallaway.instance.register_put(path, block)
end

def post(path, &block)
  Fallaway.instance.register_post(path, block)
end

class LocalFallawayClient
  attr :fallaway
  def initialize(file)
    require file
    @fallaway = Fallaway.instance
  end

  def get(path)
    @fallaway.get(path) 
  end

  def post(path, params)
    @fallaway.post(path, params) 
  end

  def put(path, params)
    @fallaway.put(path, params)
  end

  def delete(path)
    @fallaway.delete(path)
  end
end

class HttpFallawayClient
  attr :host

  def initialize(host)
    @host = host
  end

  def get(path)
    RestClient.get("#{host}#{path}")
  end

  def post(path, params)
    RestClient.post("#{host}#{path}", JSON.generate(params), {:content_type => 'application/json'} )
  end

  def put(path, params)
    RestClient.put("#{host}#{path}", JSON.generate(params), {:content_type => 'application/json'} )
  end

  def delete(path)
    RestClient.delete("#{host}#{path}")
  end

end

class FallawayClient
  def self.new_client(options)
    if options[:file] != nil
      return LocalFallawayClient.new(options[:file])
    end
    if options[:url] != nil
      return HttpFallawayClient.new(options[:url])
    end
  end
end
