class RateLimiter

  # A rate limit has been exceeded.
  class LimitExceeded < StandardError

    def initialize(available_in, type=nil)
      @available_in = available_in
      @type = type
    end

    def description
      time_left = ""
      if @available_in < 1.minute.to_i
        time_left = I18n.t("rate_limiter.seconds", count: @available_in)
      elsif @available_in < 1.hour.to_i
        time_left = I18n.t("rate_limiter.minutes", count: (@available_in / 1.minute.to_i))
      else
        time_left = I18n.t("rate_limiter.hours", count: (@available_in / 1.hour.to_i))
      end

      if @type.present?
        type_key = @type.tr("-", "_")
        msg = I18n.t("rate_limiter.by_type.#{type_key}", time_left: time_left, default: "")
        return msg if msg.present?
      end

      I18n.t("rate_limiter.too_many_requests", time_left: time_left)
    end
  end

end
