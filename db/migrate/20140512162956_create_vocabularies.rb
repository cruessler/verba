class CreateVocabularies < ActiveRecord::Migration[4.2]
  def change
    create_table :vocabularies do |t|
      t.string :name

      t.timestamps
    end
    
    create_join_table :vocabularies, :learnables, id: false do |t|
      t.index :vocabulary_id
      t.index :learnable_id
    end
    
    change_table :users do |t|
      t.integer :current_vocabulary_id
    end
  end
end
