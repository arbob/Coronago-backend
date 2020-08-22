module RewardsSponsorsRailsAdminConf
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :offer_name
        field :company_name
        field :terms_and_conditions
        field :reward_type
        field :user do
          visible do
            bindings[:view]._current_user.role == "admin"
          end
        end
        field :status do
          visible do
            bindings[:view]._current_user.role == "admin"
          end
        end
      end
      create do
        field :reward_type
        field :currency_type
        field :offer_amount
        field :offer_name
        field :company_name
        field :terms_and_conditions
        field :category, :belongs_to_association
        field :brand_logo
        field :status do
          visible do
            bindings[:view]._current_user.role == "admin"
          end
        end
        field :coupon_code
        field :coins do
          visible do
            bindings[:view]._current_user.role == "admin"
          end
        end
        field :user_id, :hidden do
          visible true
          default_value do
            bindings[:view]._current_user.id
          end
        end
     end
      configure :user do
        hide
      end
      configure :status do
        visible do
          bindings[:view]._current_user.role == "admin"
        end
      end
      configure :coins do
        visible do
          bindings[:view]._current_user.role == "admin"
        end
      end
    end
  end
end
