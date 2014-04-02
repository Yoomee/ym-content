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

  describe 'changing attribute' do
    it 'should work for content_attribute' do
      content_package.save
      content_package.title = "A new title"
      content_package.save
      content_package.reload
      expect(content_package.title).to eq("A new title")
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
    it 'can be removed' do
      content_package.photo = File.read(File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
      content_package.save
      content_package.remove_photo = true
      content_package.save
      expect(content_package.photo).to be_nil
    end
  end

  describe 'embeddable attributes' do
    it 'can be got' do
      expect{ content_package.video }.not_to raise_error
    end
    it 'can be set' do
      expect{ content_package.video_url = "http://www.youtube.com/watch?v=qvmc9d0dlOg" }.not_to raise_error
    end
    it 'are invalid with bad URL ' do
      content_package.video_url = "http://www.youtube.com/watch?v=qvmc9d0dlO"
      expect(content_package.valid?).to be_false
    end
    it 'fetches HTML' do
      content_package.video_url = "http://www.youtube.com/watch?v=qvmc9d0dlO"
      content_package.valid?
      expect(content_package.video).to_not be_blank
    end
  end

  describe 'link attributes' do
    it 'can be set as a URL' do
      url = "http://yoomee.com"
      content_package.link = url
      expect(content_package.link.value).to eq(url)
    end
    it 'can be set as a content package' do
      package_2 = FactoryGirl.create(:content_package)
      content_package.link = package_2.id
      expect(content_package.link.value).to eq(package_2)
    end
  end

  describe 'boolean attributes' do
    it 'can be got' do
      expect(content_package.special).to eq(false)
    end
    it 'can be set' do
      content_package.special = '1'
      expect(content_package.special).to eq(true)
    end
    it 'can be got with a boolean accessor' do
      expect(content_package.special?).to eq(false)
    end
  end

  describe 'tags attributes' do
    it 'can be got' do
      expect(content_package.skill_list).to eq([])
    end
    it 'can be set' do
      skills = %w{shooting hunting fishing}
      content_package.skill_list = skills.join(',')
      content_package.save
      expect(content_package.skill_list).to eq(skills)
      expect(content_package.skills.map(&:to_s)).to eq(%w{shooting hunting fishing})
    end
  end

   describe 'user attributes' do
    it 'can be got' do
      expect(content_package.person).to eq(nil)
    end
    it 'can be set as a user id' do
      content_package.person_id = User.first.id 
      content_package.save
      expect(content_package.person_id).to eq(User.first.id)
      expect(content_package.person).to eq(User.first)
    end
    it 'can be set as a user' do
      content_package.person = User.last
      content_package.save
      expect(content_package.person).to eq(User.last)
    end
  end

  it 'has a permalink if not viewless' do
    content_package.build_permalink
    content_package.valid?
    expect(content_package.permalink_path).not_to be_blank
  end

  it "doesn't have a permalink if viewless" do
    content_package.content_type.viewless = true
    content_package.build_permalink
    content_package.valid?
    expect(content_package.permalink_path).to be_nil
  end

  it 'can be deleted' do
    content_package.slug = nil
    content_package.delete
    expect(content_package.deleted?).to be_true
  end

  it 'has its children deleted too' do
    content_package.slug = nil
    content_package.children << FactoryGirl.create(:content_package, :parent => content_package, :slug => nil)
    content_package.delete
    content_package.reload
    expect(content_package.children.all?(&:deleted?)).to be_true
  end

  it 'cannot be deleted if it has a slug' do
    content_package.delete
    expect(content_package.deleted?).to be_false
  end

  it 'cannot be deleted if it has a child with a slug' do
    content_package.slug = nil
    content_package.children << FactoryGirl.build(:content_package, :parent => content_package)
    content_package.delete
    expect(content_package.deleted?).to be_false
  end

end