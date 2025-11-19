class CreateAiRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :ai_requests do |t|
      t.references     :user,   null: false, foreign_key: true
      t.text    :input_text,  null: false
      t.string    :status
      t.timestamps
    end
  end
end
