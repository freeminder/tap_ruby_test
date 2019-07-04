class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      # t.references :project, null: false
      # t.references :user, null: true

      t.timestamps
    end
    # add_reference :users, :location
  end
end
