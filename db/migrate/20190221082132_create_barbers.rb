class CreateBarbers < ActiveRecord::Migration[5.2]
  def change
    create_table :barbers do |t|
      t.text :name
      t.text :phone
      
      t.timestamps
    end
    
    Barber.create :name => 'Jon', :phone => '111'
    Barber.create :name => 'Kolyan', :phone => '222'
    Barber.create :name => 'Eva', :phone => '333'
    
  end
end
