class CreatePresencaSessaos < ActiveRecord::Migration
  def change
    create_table :presenca_sessaos do |t|
      t.integer :deputado_id
      t.integer :presenca
      t.integer :ausencia
      t.date :inicio
      t.date :fim

      t.timestamps
    end
  end
end
