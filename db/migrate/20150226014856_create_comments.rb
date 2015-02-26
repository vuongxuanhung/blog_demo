class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :entry_id
      t.text :content

      t.timestamps null: false
    end
  	add_index :comments, :user_id
  	add_index :comments, :entry_id
  end
end
