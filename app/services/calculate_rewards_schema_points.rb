class CalculateRewardsSchemaPoints < BaseService

  def call
    return returned_format(:unprocessable_entity, rewards_schema.errors.full_messages) unless rewards_schema.valid?
    returned_format(:ok, presented_data)
  end

  def input_data
    params.fetch(:input_data)
  end

  def presented_data
    presenter.constantize.new(rewards_schema).to_h
  end

  def presenter
    params.fetch(:presenter) { 'Core::RewardsSystem::Presenter::Default' }
  end

  def rewards_schema
    @rewards_schema ||= Core::RewardsSystem::RewardsSchema.new(input_data)
  end
end