class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.integer :version
      t.integer :obj_id
      t.string  :obj_type
      t.text    :content, :limit => 4294967295 # http://stackoverflow.com/questions/4443477/rails-3-migration-with-longtext

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
