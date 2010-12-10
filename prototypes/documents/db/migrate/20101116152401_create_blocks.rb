class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.text        :content
      t.integer     :position
      t.references  :document

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
