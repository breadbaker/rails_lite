require 'uri'
require 'debugger'

class Params
  def initialize(req, route_params)
    @params = {}
    encode= URI.decode_www_form(req.body)
    encode.each do |e|
      keys = parse_key(e[0])
      @params = add_key(@params,keys,e[1])
    end
    p @params
  end

  def [](key)
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
  end

  private

  def parse_www_encoded_form(enc)
    #
    # [["cat[name]", "a"],
    # ["cat[owner]", "a"],
    # ["cat[][color]", "k"],
    # ["cat[][color]", "e"]]
    #
    # >> "123 456 789" =~ /(\d\d)(\d)/
    # /((w?)[\[?\]?\[?](w?))*/
    # >> [$1, $2]
    # => ["12", "3"]
    #
    # >> $~.captures
    # => ["12", "3"]
    #
    # # hash = {}
    # # enc.map

  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/).reject{ |k| k == ''}
  end
end
