class AddMatriculaToDeputado < ActiveRecord::Migration
  def change
    add_column :deputados, :matricula, :string
  end
end
