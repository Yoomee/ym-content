require 'spec_helper'

describe ContentAttribute do
  
  let (:content_attribute) { FactoryGirl.build(:content_attribute) } 

  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:field_type) }

end