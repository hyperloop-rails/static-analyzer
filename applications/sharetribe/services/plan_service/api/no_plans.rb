module PlanService::API

  Plan = PlanService::DataTypes::Plan

  class NoPlans

    def active?
      false
    end

    def authorize(*)
      not_in_use
    end

    def create(*)
      not_in_use
    end

    def create_initial_trial(*)
      not_in_use
    end

    def get_current(community_id:)
      Result::Success.new(
        Plan.call(
        community_id: community_id,
        plan_level: PlanService::Levels::OS,
        expires_at: nil,
        created_at: Time.now,
        updated_at: Time.now).merge(expired: false, closed: false)
      )
    end

    def get_trials(*)
      not_in_use
    end

    def get_external_service_link(marketplace_data)
      Result::Error.new("Plan service is not in use.")
    end

    # private

    def not_in_use
      Result::Error.new("Plan service is not in use.")
    end
  end
end
