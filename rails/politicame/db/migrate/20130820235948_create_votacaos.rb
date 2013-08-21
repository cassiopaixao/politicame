class CreateVotacaos < ActiveRecord::Migration
  def change
    create_table :votacaos do |t|
      t.primary_key :id
      t.string :resumo
      t.datetime :data_hora
      t.string :obj_votacao
      t.boolean :master, {:default => false}
      t.belongs_to :proposicao

      t.timestamps
    end
  end
end
