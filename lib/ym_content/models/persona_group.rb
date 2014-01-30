module YmContent::PersonaGroup

  def self.included(base)
    base.has_many :personas, :foreign_key => :group_id
    base.validates :name, :presence => true
  end

end