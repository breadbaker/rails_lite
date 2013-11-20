require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    route_params.parse_www_encoded_form
    @params = route_params


    @req = req
    @res = res
  end

  def session
    @session ||= Session.new(@req)
  end

  def params
    @params
  end

  def get_binding
    binding
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content

    session.store_session(@res)
    @already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    file_path = "views/#{controller_name}/#{template_name}.html.erb"
    content = ERB.new(File.read(file_path)).result(self.get_binding)
    render_content(content,'text/html')
  end

  def invoke_action(name)
    self.send(name)
  end
end
