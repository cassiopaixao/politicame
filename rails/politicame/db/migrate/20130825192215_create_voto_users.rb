class CreateVotoUsers < ActiveRecord::Migration
  def change
    create_table :voto_users do |t|
      t.integer :user_id
      t.integer :votacao_id
      t.integer :voto

      t.timestamps
    end
  end
end
