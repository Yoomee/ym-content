class AddDefaultAttributeIdToContentAttributes < ActiveRecord::Migration
  def change
    add_column :content_attributes, :default_attribute_id, :integer, :after => :meta_tag_name
  end
end
