module YmContent::PersonaGroup

  def self.included(base)
    base.has_many :personas, :foreign_key => :group_id
    base.validates :name, :presence => true
  end

  def to_s
    name
  end

end