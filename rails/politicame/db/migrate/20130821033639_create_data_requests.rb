class CreateDataRequests < ActiveRecord::Migration
  def change
    create_table :data_requests do |t|
      t.primary_key :id
      t.string :host
      t.string :path
      t.string :query_str
      t.datetime :when
      t.integer :status_code

      t.timestamps
    end
  end
end
