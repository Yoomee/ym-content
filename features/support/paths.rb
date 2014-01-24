module NavigationHelpers
  def path_to(object)
    case object
    when String
      object
    else
      raise "Can't find path for \"#{object}\".\n" +
      "Add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)
