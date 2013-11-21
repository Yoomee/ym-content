require 'spec_helper'

describe ContentPackage do
  
  let (:content_package) { FactoryGirl.build(:content_package) } 
  
  it 'is valid' do
    expect(content_package.valid?).to be_true
  end
  
  describe 'getting attribute' do
    it 'should work for content_attribute' do
      expect{ content_package.title }.not_to raise_error
    end
    it 'should not work for other attributes' do
      expect{ content_package.title2 }.to raise_error
    end
  end
  
  describe 'setting attribute' do
    it 'should work for content_attribute' do
      content_package.title = "A new title"
      expect(content_package.title).to eq("A new title")
    end
    it 'should not work for other attributes' do
      expect{ content_package.title2 = "title" }.to raise_error
    end
  end

  
end