class StuckCiBuildsWorker
  include Sidekiq::Worker

  BUILD_STUCK_TIMEOUT = 1.day

  def perform
    Rails.logger.info 'Cleaning stuck builds'

    builds = Ci::Build.running_or_pending.where('updated_at < ?', BUILD_STUCK_TIMEOUT.ago)
    builds.find_each(batch_size: 50).each do |build|
      Rails.logger.debug "Dropping stuck #{build.status} build #{build.id} for runner #{build.runner_id}"
      build.drop
    end

    # Update builds that failed to drop
    builds.update_all(status: 'failed')
  end
end
