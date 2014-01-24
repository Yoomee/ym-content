FactoryGirl.define do
  
  factory :content_type do
    name "Blog post"
    description "Share your latest news"
    singleton false
    view_name 'blog_post'
    use_workflow true
    after(:build) do |content_type|
      if content_type.content_attributes.count.zero?
        content_type.content_attributes = [
          FactoryGirl.build(:content_attribute, :content_type => content_type, :limit_unit => 'character', :limit_quantity => 150),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'text', :name => 'Text', :description => 'Tell a story')
        ]
      end
    end
  end
  
  factory :content_attribute do
    content_type
    slug "title"
    name "Title"
    description "Choose a pithy title"
    field_type 'text'
    sequence(:position)
  end
  
  factory :content_package do
    content_type
    sequence(:slug){|n| "content_package_#{n}" }
  end

  factory :user do
    first_name "Charles"
    sequence(:last_name) {|n| "Barrett #{n}"}
    sequence(:email) {|n| "charles@barrett_#{n}.com"}
    password "password"
  end

end