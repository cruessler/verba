class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :learnable_id
      t.integer :user_id
      t.integer :repetition
      t.integer :interval
      t.datetime :next_review
      t.float :e_factor
      t.integer :rating

      t.timestamps
    end    
    add_index :ratings, :user_id
    add_index :ratings, :learnable_id
    add_index :ratings, :next_review
    add_index :ratings, :rating
    
    change_table :learnables do |t|
      t.remove :repetition
      t.remove :interval
      t.remove :next_review
      t.remove :e_factor
      t.remove :rating
    end
  end
end
