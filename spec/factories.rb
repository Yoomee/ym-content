FactoryGirl.define do
  
  factory :content_type do
    name "Blog post"
    description "Share your latest news"
    singleton false
    view_name 'blog_post'
    use_workflow true
    after(:build) do |content_type|
      content_type.content_attributes = [
        FactoryGirl.build(:content_attribute, :limit_unit => 'character', :limit_quantity => 150),
        FactoryGirl.build(:content_attribute, :slug => 'text', :name => 'Text', :description => 'Tell a story')
      ]
    end
  end
  
  factory :content_attribute do
    slug "title"
    name "Title"
    description "Choose a pithy title"
    field_type 'text'
    sequence(:position)
  end
  
  factory :content_package do
    content_type
  end
  
end