class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      # t.references :project, null: false
      # t.references :roleable, polymorphic: true, index: true

      t.timestamps
    end
    # add_reference :users, :role
  end
end
