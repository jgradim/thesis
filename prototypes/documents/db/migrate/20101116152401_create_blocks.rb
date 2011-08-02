class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.text        :content, :limit => 4294967295 # http://stackoverflow.com/questions/4443477/rails-3-migration-with-longtext
      t.integer     :position
      t.references  :document

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
