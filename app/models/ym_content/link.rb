require 'public_suffix'

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
        if @url.match(/\A[^@\s]+@([^@.\s]+\.)*[^@.\s]+\z/)
          # is email-like
          @url = 'mailto:' + @url
        else
          # is this even a URL? (Until we have validation, keep broken text)
          begin
            URI.parse(@url)
          rescue
          else
            begin
              parsed = PublicSuffix.parse(@url)
            rescue
              # must be internal/relative 
            else
              # must be external, add scheme if doesn't exist
              @url = 'http://' + @url if URI.parse(@url).scheme.nil?
            end
          end
        end
        if url.start_with?('/')
          @target = nil
        else
          @target = "_blank"
        end
      end
    end

    def email?
      return @url.match(/[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]\.)[a-zA-Z]{2,4}/)
    end

    def value
      content_package.presence || url
    end

    def raw
      @raw
    end

  end
end