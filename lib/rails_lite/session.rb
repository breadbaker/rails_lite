require 'json'
require 'webrick'

class Session
  NAME = '_rails_lite_app'
  def initialize(req)
    @session = {}
    p req.cookies
    req.cookies.each do |c|
      @session = JSON.parse(c.value) if c.name == NAME
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new(NAME, JSON.dump(@session))
    cookie.expires = Time.now + (2*7*24*60*60)
    res.cookies << WEBrick::Cookie.new(NAME, JSON.dump(@session))
  end
end
