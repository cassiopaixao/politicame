class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.primary_key :id
      t.string :name
      t.string :email
      t.timestamp :subscribed_at

      t.timestamps
    end
  end
end
