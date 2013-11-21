module YmContent::ContentPackagesController
  
  def self.included(base)
    base.load_and_authorize_resource
  end
  
  def new
  end
  
end