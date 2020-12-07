class V1::RewardsController < ApplicationController

  def calculate
    response = CalculateRewardsSchemaPoints.call({input_data: request.raw_post, presenter: rewards_presenter_param})
    render json: response[:data], status: response[:status]
  end

  private

  def rewards_presenter_param
    params.fetch(:rewards_presenter) { 'Core::RewardsSystem::Presenter::CalculatedPoints' }
  end
end