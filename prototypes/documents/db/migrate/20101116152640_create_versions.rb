class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.integer :object_id
      t.string  :object_type
      t.text    :content

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
