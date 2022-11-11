class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.string :title, null: false, limit: 255
      t.text :description
      t.belongs_to :status
      t.belongs_to :priority
      t.datetime :deadline # null: false, default: 'now()'
      # t.datetime :next_notification
      # t.integer :repeat, default: 0
      # t.datetime :start_repeating_from_date, default: 'now()'

      t.timestamps
    end
  end
end
