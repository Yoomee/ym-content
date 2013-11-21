class CreateContentChunks < ActiveRecord::Migration

  def change
    create_table :content_chunks do |t|
      t.belongs_to :content_package
      t.belongs_to :content_attribute
      t.text :value
      t.timestamps
    end
    add_index :content_chunks, [:content_package_id, :content_attribute_id], :unique => true, :name => 'index_content_on_package_attribute'
  end

end