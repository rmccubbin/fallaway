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
end
