# frozen_string_literal: true

module Mutations
  module Plans
    class Update < BaseMutation
      include AuthenticableApiUser

      graphql_name 'UpdatePlan'
      description 'Updates an existing Plan'

      argument :id, String, required: true
      argument :name, String, required: true
      argument :code, String, required: true
      argument :frequency, Types::Plans::FrequencyEnum, required: true
      argument :billing_period, Types::Plans::BillingPeriodEnum, required: true
      argument :pro_rata, Boolean, required: true
      argument :pay_in_advance, Boolean, required: true
      argument :amount_cents, Integer, required: true
      argument :amount_currency, Types::CurrencyEnum, required: true
      argument :vat_rate, Float, required: false
      argument :trial_period, Float, required: false
      argument :description, String, required: false

      argument :charges, [Types::Charges::Input]

      type Types::Plans::Object

      def resolve(**args)
        result = PlansService.new(context[:current_user]).update(**args)

        result.success? ? result.plan : execution_error(code: result.error_code, message: result.message)
      end
    end
  end
end
