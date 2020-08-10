class PopulateStanceChoicesCacheWorker
  include Sidekiq::Worker

  def perform(from)
    Stance.where("cast_at is not null and latest = true and stance_choices_cache = '[]'::jsonb").where("id > ?", from).order("id").limit(1000).each do |stance|
      stance.update_stance_choices_cache
      stance.save(validate: false)
    end
  end
end
