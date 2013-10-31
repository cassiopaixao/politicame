class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :embed_url
      t.string :embed_type
      t.string :source_title
      t.string :source_name
      t.string :source_url

      t.timestamps
    end
  end
end
