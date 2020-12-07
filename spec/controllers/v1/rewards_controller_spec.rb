require 'rails_helper'
require 'shared_context/valid_input'

RSpec.describe 'Rewards', type: 'request' do
  include_context 'valid_input_data'

  describe 'calculate' do
    it 'return errors' do
      post '/v1/rewards/calculate'
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq ["Input data can't be blank"]
    end

    it 'returns the json with points' do
      expected_result = { A: 1.75, B: 1.5, C: 1 }.with_indifferent_access
      post '/v1/rewards/calculate', params: input_data, headers: {}
      expect(JSON.parse(response.body)).to eq expected_result
    end
  end
end
