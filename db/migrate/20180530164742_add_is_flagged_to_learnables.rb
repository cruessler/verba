class AddIsFlaggedToLearnables < ActiveRecord::Migration[5.1]
  def change
    change_table :learnables do |t|
      t.boolean :is_flagged, default: false, index: true
    end
  end
end
