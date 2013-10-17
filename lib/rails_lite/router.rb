class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name = 
              pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    @http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
    controller = @controller_class.new
    controller.invoke_action(@action_name)
    # req, res ?
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    @routes.each do |route|
      route.instance_eval(&proc)
    end
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.http_method == req.request_method
    end

    nil
  end

  def run(req, res)
    route = match(req)
    if !!route
      route.run(req, res)
    else
      res.status = 404
    end
  end
end
