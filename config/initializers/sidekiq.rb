require "sidekiq"
require "sidekiq-cron"
require "sidekiq/web"
require "sidekiq/cron/web"
Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/sidekiq_schedule.yml"

    if File.exist?(schedule_file)
      schedule = YAML.load_file(schedule_file)

      Sidekiq::Cron::Job.load_from_hash!(schedule, source: "schedule")
    end
  end
end
