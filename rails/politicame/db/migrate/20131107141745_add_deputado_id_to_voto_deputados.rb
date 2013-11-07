class AddDeputadoIdToVotoDeputados < ActiveRecord::Migration

  def change
    add_column :voto_deputados, :deputado_id, :integer
  end
end
