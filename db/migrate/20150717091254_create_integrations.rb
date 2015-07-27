class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.integer :service
      t.string :api_key
      t.string :list_id
      t.string :list_name

      t.timestamps null: false
    end
  end
end
