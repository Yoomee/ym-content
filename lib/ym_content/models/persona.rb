module YmContent::Persona

  def self.included(base)
    base.image_accessor :image
    base.file_accessor :file
  end

end