class AddPublishedAtToContentPackage < ActiveRecord::Migration
  def change
    add_column :content_packages, :publish_at, :date
  end
end
