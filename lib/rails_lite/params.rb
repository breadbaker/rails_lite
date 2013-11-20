require 'uri'
require 'debugger'

class Params
  def initialize(req, route_params = nil)
    @req = req
    @params = {}
    if route_params
      route_params.names.each do |n|
        n = n.to_sym
        @params[n] = route_params[n]
      end
    end    #
    # p req.query_str
    # req.query_string.split('&').reject do |e|
    #   e == ''
    # end.each  do |i|
    #   a = i.split('=')
    #   p a
    #   @params[a[0]] = a[1]
    # end
  end

  def params
    @params
  end

  def [](key)
    @params[key]
  end

  def add_key(p,e,v)
    if e.empty?
      return v if p.nil?
      return [p,v] unless p.class == Array
      return p << v
    end
    p = {} if p.nil?
    p.merge({ e.first => add_key(p[e.first],e.drop(1),v) })
  end

  def to_s
    @params.to_s
  end


  def parse_www_encoded_form
    enc = @req.body
    return unless enc
    encode= URI.decode_www_form(enc)
    encode.each do |e|
      keys = parse_key(e[0])
      @params = add_key(@params,keys,e[1])
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/).reject{ |k| k == ''}
  end
end
