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
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'title', :limit_unit => 'character', :limit_quantity => 30),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'text', :name => 'Text', :field_type => 'text', :description => 'Tell a story', :limit_unit => 'word', :limit_quantity => 30),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'photo', :name => 'Photo', :field_type => 'image', :description => 'Add a picture'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'document', :name => 'Document', :field_type => 'file', :description => 'Add a file'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'video', :name => 'Video', :field_type => 'embeddable', :description => 'Add a video'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'link', :name => 'Link', :field_type => 'link', :description => 'Add a link'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'special', :name => 'Is this special?', :field_type => 'boolean', :description => 'Yes or no'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'skills', :name => 'Skills', :field_type => 'tags', :description => 'list some skills'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'person', :name => 'Person', :field_type => 'user', :description => 'Choose someone'),
          FactoryGirl.build(:content_attribute, :content_type => content_type, :slug => 'geo', :name => 'Location', :field_type => 'location', :description => 'Pick a location')
        ]
      end
    end
  end

  factory :content_attribute do
    content_type
    slug "title"
    name "Title"
    description "Choose a pithy title"
    field_type 'string'
    sequence(:position)
  end

  factory :user, :aliases => [:author, :requested_by]  do
    first_name "Charles"
    sequence(:last_name) {|n| "Barrett #{n}"}
    sequence(:email) {|n| "charles@barrett_#{n}.com"}
    password "password"
    role "admin"

    trait :author do
      before(:create) { |user| user.role = "author" }
    end
    trait :admin do
      after(:create) {|user| user.role = "admin" }
    end
  end

  factory :activity_item do
    user
  end

  factory :content_package do
    sequence(:name) {|n| "Content package #{n}"}
    content_type
    review_frequency 1
    due_date Date.today + 6.months
    author
    requested_by
    status "published"
    sequence(:slug){|n| "content_package_#{n}" }
    after(:build) do |content_package|
      FactoryGirl.create(:activity_item, :resource_type => "ContentPackage", :resource => content_package)
    end
  end

  factory :persona_group, :aliases => [:group] do
    sequence(:name){|n| "Persona group #{n}" }
  end

  factory :persona do
    group
    sequence(:name){|n| "Bob Smith #{n}" }
    category "Persona category"
    age 18
    summary "Persona summary"
    benefit_1 "Benefit 1"
    benefit_2 "Benefit 2"
    benefit_3 "Benefit 3"
    benefit_4 "Benefit 4"
  end

end
