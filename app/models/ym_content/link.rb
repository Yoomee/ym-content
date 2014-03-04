module YmContent
  class Link

    attr_reader :url, :content_package, :target

    def initialize(value)
      if value.strip =~ /^\d+$/
        @content_package = ::ContentPackage.find_by_id(value)
        @target = nil
      else
        @url = value.strip.html_safe
        if value.start_with?('/')
          @target = nil
        else
          @target = "_blank"
        end
      end
    end

    def value
      content_package.presence || url
    end

  end
end