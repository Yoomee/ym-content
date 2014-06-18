module StylesHelper

  def inline_styles(hash)
    if image = hash.delete(:background_image)
      hash[:background] = "#{hash.delete(:background_color)} url(#{image.thumb('1200x').url}) no-repeat center center"
      hash[:background_size] = "cover"
    end
    css = hash.map{|key,value| "#{key.to_s.gsub('_','-')}:#{value};"}.join()
  end

end
