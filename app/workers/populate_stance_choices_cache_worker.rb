class PopulateStanceChoicesCacheWorker
  include Sidekiq::Worker

  def perform
    query = Stance.joins("INNER JOIN stance_choices on stances.id = stance_choices.stance_id").
                   where("stance_choices.id is not null and cast_at is not null and latest = true and stance_choices_cache = '[]'::jsonb")

    count = query.count
    puts "stances remaining", count
    return unless count > 0

    query.includes(stance_choices: :poll_option).order("id desc").limit(10000).each do |stance|
      stance.update_stance_choices_cache!
    end

    PopulateStanceChoicesCacheWorker.perform_async
  end
end
