class AddUnsubscribedAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :unsubscribed_at, :timestamp
  end
end
