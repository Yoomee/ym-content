require 'spec_helper'

describe ContentType do
  
  let (:content_type) { FactoryGirl.build(:content_type) }
  
  it 'is valid' do
    expect(content_type.valid?).to be_true
  end
  
end