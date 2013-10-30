class CreateTwitters < ActiveRecord::Migration
  def change
    create_table :twitters do |t|
      t.integer :deputado_id
      t.string :address

      t.timestamps
    end
  end
end
