module YmContent::Persona

  def self.included(base)
    base.belongs_to :group, :class_name => "PersonaGroup"
    base.image_accessor :image
    base.file_accessor :file
    base.validate :group_name_is_valid
  end

  def benefits
    [ benefit_1, benefit_2, benefit_3, benefit_4 ].select(&:present?).compact
  end

  def group_name
    if group && group.new_record?
      group.name
    else
      nil
    end
  end

  def group_name=(name)
    self.group = PersonaGroup.new(:name => name)
  end
  
  private
  def group_name_is_valid
    return true unless group
    group.valid?
    group.errors.each do |attr, message|
      self.errors.add(:group_name, message)
    end
    group.errors.blank?
  end

end