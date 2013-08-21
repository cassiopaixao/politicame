class CreateVotoDeputados < ActiveRecord::Migration
  def change
    create_table :voto_deputados do |t|
      t.primary_key :id
      t.string :nome
      t.string :partido
      t.string :uf
      t.integer :voto
      t.belongs_to :votacao

      t.timestamps
    end
  end
end
