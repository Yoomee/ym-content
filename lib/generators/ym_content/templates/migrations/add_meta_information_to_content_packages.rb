class AddMetaInformationToContentPackages < ActiveRecord::Migration
  def change
    add_column :content_packages, :meta_title, :string
    add_column :content_packages, :meta_description, :text
    add_column :content_packages, :meta_keywords, :string
    add_column :content_packages, :meta_image_uid, :string
    add_column :content_packages, :meta_image_name, :string
  end
end
