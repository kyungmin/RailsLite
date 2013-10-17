require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = nil)
    @req = req
    @res = res
    @route_params = route_params
    @already_built_response = false
    @params = Params.new(@req, @route_params)

  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    session.store_session(@res)
    @res.status = 302
    @res['Location'] = url
#    @res.set_redirect(@res.status_line, url) # this doesn't work
    @already_built_response = true
  end

  def render_content(content, type)
    session.store_session(@res)
    @res.content_type = type
    @res.body = content
    @already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.name.underscore    
    f = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(f)
    result = template.result(binding)   
#    fbind.eval(result)
    render_content(result, "text/text")
  end

  def invoke_action(name)
  end
end
