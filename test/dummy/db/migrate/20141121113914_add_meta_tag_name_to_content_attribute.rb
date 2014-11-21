class AddMetaTagNameToContentAttribute < ActiveRecord::Migration
  def change
    add_column :content_attributes, :meta_tag_name, :string, :after => :meta
  end
end
