require_relative 'routes/cms'
require_relative 'routes/cms_admin'

class ActionDispatch::Routing::Mapper
  def ym_content_route(identifier, options = {})
    send("ym_content_route_#{identifier}", options)
  end
end