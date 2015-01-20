class ActionDispatch::Routing::Mapper

  def ym_content_route_cms(options = {})
    scope "/#{options[:path]}".squeeze('/') do
      get ':path/edit', to: "content_packages#edit"
      get "*path", to: "content_packages#show"
    end
  end

end