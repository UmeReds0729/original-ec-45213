class AddPeopleToAiRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :ai_requests, :people, :integer
  end
end
