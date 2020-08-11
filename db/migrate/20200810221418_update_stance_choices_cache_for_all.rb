class UpdateStanceChoicesCacheForAll < ActiveRecord::Migration[5.2]
  def change
    PopulateStanceChoicesCacheWorker.perform_async
  end
end
