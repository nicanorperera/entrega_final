class CreateBookings < ActiveRecord::Migration
def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :status
      t.string :user
      t.references :resource
      
      t.timestamps
    end
  end
end
