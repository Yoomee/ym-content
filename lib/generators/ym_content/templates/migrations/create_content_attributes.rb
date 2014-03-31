class CreateContentAttributes < ActiveRecord::Migration

  def change
    create_table :content_attributes do |t|
      t.belongs_to :content_type
      t.string :slug
      t.string :name
      t.text :description
      t.string :field_type
      t.integer :limit_quantity
      t.string :limit_unit
      t.integer :position, :default => 0
      t.boolean :required, :default => false
      t.boolean :meta, :default => false
    end
    add_index :content_attributes, :content_type_id
  end

end