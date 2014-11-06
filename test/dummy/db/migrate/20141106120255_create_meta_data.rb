class CreateMetaData < ActiveRecord::Migration
  def change
    create_table :meta_data do |t|
      t.string :page_slug
      t.string :title
      t.text :description
      t.string :keywords
      t.string :image_uid
      t.string :image_name

      t.timestamps
    end
  end
end
