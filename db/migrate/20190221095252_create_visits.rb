class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :client_id
      t.integer :barber_id
      t.text :date_time
      
      t.timestamps
    end
  end
end
