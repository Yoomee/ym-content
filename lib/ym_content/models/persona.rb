module YmContent::Persona

  def self.included(base)
    base.image_accessor :image
    base.file_accessor :file
  end

  def benefits
    [ benefit_1, benefit_2, benefit_3, benefit_4 ].select(&:present?).compact
  end

end