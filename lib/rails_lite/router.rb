class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    @match_data = @pattern.match(req.path)
    (!!@match_data && req.request_method.downcase.to_sym == @http_method)
  end

  def run(req, res)
    params = Params.new(req,@match_data)
    c = @controller_class.new(req, res, params)
    c.invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new( pattern, method, controller_class, action_name )
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do | path, controller, action|
      add_route( path, http_method, controller, action)
    end
  end

  def match(req)
    @routes.each do |rout|
      return rout if rout.matches?(req)
    end
    raise "No Route Found"
  end

  def run(req, res)
    match(req).run(req,res)
  end
end
