class CreateDeputados < ActiveRecord::Migration
  def change
    create_table :deputados do |t|
      t.string :nome
      t.string :uf
      t.string :partido
      t.string :email
      t.string :telefone
      t.string :condicao
      t.primary_key :id

      t.timestamps
    end
  end
end
