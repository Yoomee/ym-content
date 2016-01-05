module YmContent
  class Engine < ::Rails::Engine
    config.nested_permalinks = false
    config.permitted_email = proc { true }
  end
end
