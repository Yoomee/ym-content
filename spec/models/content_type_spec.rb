require 'spec_helper'

describe ContentType do
  
  let (:content_type) { FactoryGirl.build(:content_type) }
  
  it 'is valid' do
    expect(content_type.valid?).to be_true
  end
  
  describe 'missing_view?' do

    it 'returns false if viewless' do
      content_type.viewless = true
      expect(content_type.missing_view?).to be_false
    end

    it 'returns true if view does not exist' do
      content_type.viewless = false
      expect(content_type.missing_view?).to be_true
    end

    it 'returns true if view exists' do
      views_path = "#{Rails.root}/app/views/content_packages/views"
      `mkdir -p #{views_path}`
      `touch #{views_path}/#{content_type.view_name}.html.haml`
      expect(content_type.missing_view?).to be_false
      `rm -rf #{views_path}`
    end

  end
end