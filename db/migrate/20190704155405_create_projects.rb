class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false

      # t.references :projectable, polymorphic: true, index: true

      t.timestamps
    end
    # add_reference :users, :project
  end
end
