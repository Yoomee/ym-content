require 'spec_helper'

describe ContentPackage do
  
  let (:content_package) { FactoryGirl.build(:content_package) }

  it { should validate_presence_of(:content_type) }

  it 'is valid' do
    content_package.valid?
    expect(content_package.errors.full_messages).to eq([])
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

  describe 'required fields' do
    it 'should be required' do
      content_package.save
      ca = content_package.content_attributes.first
      ca.required = true
      content_package.send("#{ca.slug}=",nil)
      expect(content_package).to_not be_valid
    end
  end

  describe 'image attributes' do
    it 'can be got' do
      expect{ content_package.photo }.not_to raise_error
    end
    it 'can be set' do
      expect{ content_package.photo = File.read(File.join(Rails.root, 'public/dragonfly/defaults/user.jpg')) }.not_to raise_error
    end
    it 'can generate thumbnail' do
      content_package.photo = File.read(File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
      expect(content_package.photo.thumb('100x100#').url).to match(/^\/media\//)
    end
  end

end