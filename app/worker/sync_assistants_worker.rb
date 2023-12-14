class SyncAssistantsWorker
  include Sidekiq::Worker

  def perform
    puts "run sync assistants worker"
    service = OpenaiServices::SyncAssistants.new(ENV["OPENAI_API_KEY"])
    result = service.call
    if result[:error].present?
      puts "sync assistants error"
    else
      puts result.to_json
    end
    puts "run sync assistants worker done"
  end
end
