class CreateProposicaos < ActiveRecord::Migration
  def change
    create_table :proposicaos do |t|
      t.primary_key :id
      t.string :tipo
      t.integer :numero
      t.integer :ano
      t.string :autor_nome
      t.string :autor_partido
      t.string :autor_uf
      t.integer :qtd_autores
      t.datetime :data_apresentacao
      t.text :ementa
      t.text :ementa_explicacao

      t.timestamps
    end
  end
end
