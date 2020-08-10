class UpdateStanceChoicesCacheForAll < ActiveRecord::Migration[5.2]
  def change
    i = 0
    total = Stance.count
    while (i < total) do
      puts "PopulateStanceChoicesCacheWorker.perform_async(#{i})"
      PopulateStanceChoicesCacheWorker.perform_async(i)
      i += 1000
    end
  end
end
