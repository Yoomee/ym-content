class CreateTagCategories < ActiveRecord::Migration
  def change
    create_table :tag_categories do |t|
      t.string :name
      t.string :slug
    end
  end
end
