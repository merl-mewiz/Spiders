class CreatePriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :priorities do |t|
      t.string :title, null: false
      t.string :color_class, null: false
    end
  end
end
