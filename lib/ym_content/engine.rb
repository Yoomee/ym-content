module YmContent
  class Engine < ::Rails::Engine
    config.nested_permalinks = true
    config.tags_feature = false
  end
end
