class CreateContentPackages < ActiveRecord::Migration

  def change
    create_table :content_packages do |t|
      t.string :slug
      t.belongs_to :content_type
      t.belongs_to :parent
      t.belongs_to :author
      t.string :status, :default => 'draft'
      t.text :notes
      t.date :due_date
      t.timestamps
    end
    add_index :content_packages, :parent_id
    add_index :content_packages, :slug
  end

end