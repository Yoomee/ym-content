module YmContent
  class Engine < ::Rails::Engine
    config.nested_permalinks = false
    config.use_ym_permalinks = false
  end
end
