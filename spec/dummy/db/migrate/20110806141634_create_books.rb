class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.integer :author_id
      t.integer :genre_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
