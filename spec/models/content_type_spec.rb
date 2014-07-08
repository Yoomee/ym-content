require 'spec_helper'

describe ContentType do
  
  let (:content_type) { FactoryGirl.build(:content_type) }
  
  it 'is valid' do
    expect(content_type.valid?).to be_truthy
  end
  
  it 'can be destroyed if has no content packages' do
    content_type.save
    expect(content_type.destroy).to be_truthy
  end

  it 'cannot be destroyed if has content packages' do
    content_type.save
    content_type.content_packages << FactoryGirl.create(:content_package, :content_type => content_type)
    expect(content_type.destroy).to be_falsey
  end

  describe 'missing_view?' do

    it 'returns false if viewless' do
      content_type.viewless = true
      expect(content_type.missing_view?).to be_falsey
    end

    it 'returns true if view does not exist' do
      content_type.viewless = false
      expect(content_type.missing_view?).to be_truthy
    end

    it 'returns true if view exists' do
      views_path = "#{Rails.root}/app/views/content_packages/views"
      `mkdir -p #{views_path}`
      `touch #{views_path}/#{content_type.view_name}.html.haml`
      expect(content_type.missing_view?).to be_falsey
      `rm -rf #{views_path}`
    end

  end
end