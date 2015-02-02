require 'spec_helper'

describe ContentAttribute do
  
  let (:content_attribute) { FactoryGirl.build(:content_attribute, :slug => "banana", :name => "Banana") } 

  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:field_type) }

  it 'is valid' do
    expect(content_attribute.valid?).to be_truthy
  end

  describe 'slug' do
    it 'is set after validation' do
      content_attribute.slug = nil
      content_attribute.name = "Apple"
      content_attribute.valid?
      expect(content_attribute.slug).to eq("apple")
    end

    it 'cannot conflict with existing method' do
      content_attribute.slug = nil
      content_attribute.name = "Test"
      content_attribute.valid?
      expect(content_attribute.slug).to_not eq("test")
    end
  end

end