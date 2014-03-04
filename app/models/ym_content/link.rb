module YmContent
  class Link

    attr_reader :url, :content_package, :target

    def initialize(val)
      @raw = val.strip
      if raw =~ /^\d+$/
        @content_package = ::ContentPackage.find_by_id(raw)
        @target = nil
      else
        @url = val.to_s.html_safe
        if url.start_with?('/')
          @target = nil
        else
          @target = "_blank"
        end
      end
    end

    def value
      content_package.presence || url
    end

    def raw
      @raw
    end

  end
end