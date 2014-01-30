class CreatePersonas < ActiveRecord::Migration

  def change
    create_table :personas do |t|
      t.belongs_to :group
      t.string :name
      t.integer :age
      t.text :summary
      t.text :benefit_1
      t.text :benefit_2
      t.text :benefit_3
      t.text :benefit_4
      t.string :image_uid
      t.string :file_uid
      t.timestamps
    end
    add_index :personas, :group_id

    create_table :content_packages_personas, :id => false do |t|
      t.belongs_to :content_package
      t.belongs_to :persona
    end
    add_index :content_packages_personas, :content_package_id

    create_table :persona_groups do |t|
      t.string :name
      t.integer :position, :default => 0
      t.timestamps
    end
  end

end
