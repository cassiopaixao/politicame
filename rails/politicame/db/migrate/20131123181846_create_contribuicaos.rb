class CreateContribuicaos < ActiveRecord::Migration
  def change
    create_table :contribuicaos do |t|
      t.primary_key :id
      t.string :autor
      t.string :fonte
      t.string :rotulo
      t.text :conteudo
      t.belongs_to :proposicao

      t.timestamps
    end
  end
end
