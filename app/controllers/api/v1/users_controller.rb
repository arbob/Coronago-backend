class Api::V1::UsersController < Api::BaseController
  before_action :validate_reward_id, :already_redeemed, only: :redeem_rewards

  def show
    current_user = User.includes(redeemed_rewards: :rewards_sponsor).where(id: @api_current_user.id).first
    render json: current_user
  end

  def update
    current_user.update!(user_params)
    render json: current_user
  end
  # API for redeem rewards
  # POST   /api/v1/user/redeem_rewards
  # body ex:
  # {
  #   "rewards_sponsor_id": 3
  # }
  def redeem_rewards
    if current_user.wallet_balance.to_i >= @reward.coins
      current_user.redeemed_rewards.create(rewards_sponsor: @reward)
      render json: {coupon_code: @reward.coupon_code}
    else
      render_error(:unprocessable_entity, 'Insufficient coins')
    end
  end

  def badges
    badges = Badge.all
    render json: {
                   total_earned_coins: current_user.total_earned_coins,
                   badges: ActiveModel::Serializer::CollectionSerializer.new(badges, each_serializer: BadgeSerializer)
                 }
  end

  private

  def user_params
    params.permit(:name, :mobile, :profile_picture, :lat, :lng)
  end

  # Ensures that the reward exists
  def validate_reward_id
    reward_id = params[:rewards_sponsor_id].to_i # prevents SQL injection
    if RewardsSponsor.exists?(reward_id)
      @reward = RewardsSponsor.find(reward_id)
    else
      render_error(:unprocessable_entity, 'Reward not found')
    end
  end

  def already_redeemed
    if RedeemedReward.exists?(user: current_user, rewards_sponsor: @reward)
      render_error(:unprocessable_entity, 'Already Redeemed')
    end
  end
end
