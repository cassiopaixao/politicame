class AddIdCamaraToDeputados < ActiveRecord::Migration
  def change
    add_column :deputados, :id_camara, :integer
  end
end
