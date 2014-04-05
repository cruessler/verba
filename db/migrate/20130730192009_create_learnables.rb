class CreateLearnables < ActiveRecord::Migration
  def change
    create_table :learnables do |t|
      t.string :type
      
      t.string :lemma
      t.string :long_lemma
      t.string :phrase
      t.string :translation
      
      t.integer :repetition
      t.integer :interval
      t.datetime :next_review
      t.float :e_factor
      t.integer :rating

      t.timestamps
    end
    add_index :learnables, :lemma
    add_index :learnables, :next_review
    add_index :learnables, :rating
  end
end
