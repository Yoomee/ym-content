module YmContent
  class Link

    attr_reader :value, :target

    def initialize(value)
      if value.strip =~ /^\d+$/
        @value = ::ContentPackage.find_by_id(value)
        @target = nil
      else
        @value = value.strip.html_safe
        @target = "_blank"
      end
    end

  end
end