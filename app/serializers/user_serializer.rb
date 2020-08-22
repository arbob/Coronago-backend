class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email, :mobile, :profile_picture_url, :wallet_balance,
             :home_duration_in_seconds, :lat, :lng
  has_many :redeemed_rewards, serializer: RedeemedRewardSerializer
  has_one :referral

  def home_duration_in_seconds
    active_session = object.active_session
    if active_session.present? && active_session.home?
      object.home_duration_in_seconds + Sessions::Duration.in_seconds(active_session)
    else
      object.home_duration_in_seconds
    end
  end

  def wallet_balance
    active_session = object.active_session
    if active_session.present?
      object.wallet_balance + Sessions::Rewards.calculate(active_session.session_type,
                                  Sessions::Duration.in_minutes(active_session))
      # Uncomment this code when we start coins deduction

      # dynamic_balance = Sessions::Rewards.calculate(active_session.session_type, Sessions::Duration.in_minutes(active_session))
      # if dynamic_balance.negative? && object.wallet_balance >= dynamic_balance.abs
      #   object.wallet_balance + dynamic_balance
      # elsif dynamic_balance.positive?
      #   object.wallet_balance + dynamic_balance
      # end
    else
      object.wallet_balance
    end
  end
end
