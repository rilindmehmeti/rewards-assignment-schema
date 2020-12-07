require 'rails_helper'

describe Core::RewardsSystem::Customer do
  let(:identifier) { 'Rilind' }
  let(:recommended_by) { nil }
  let(:accepted) { false }
  let(:customer) { described_class.new(identifier, recommended_by, accepted) }
  describe 'initialize' do

    it { expect(customer.identifier).to eq identifier }
    it { expect(customer.recommended_by).to be_nil }
    it { expect(customer.accepted).to eq accepted }
    it { expect(customer.points).to eq 0 }

    context 'when initialized with recommended_by' do
      let(:recommended_by) { described_class.new('Batman', nil, true) }
      it { expect(customer.recommended_by).not_to be_nil }
      it { expect(customer.recommended_by).to eq recommended_by }
    end

    context 'valid initializations' do
      it 'should be valid with 2 params' do
        expect { described_class.new('A', 3) }.not_to raise_error
      end

      it 'should be valid with 3 params' do
        expect { described_class.new('A', 3, 4) }.not_to raise_error
      end
    end

    context 'invalid initializations' do
      it 'should be invalid with 1 param' do
        expect { described_class.new('A') }.to raise_error(ArgumentError)
      end

      it 'should be invalid with 4 params' do
        expect { described_class.new('A', 1, 2, 3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.add_points' do
    let(:customer) { described_class.new('Rilind', nil) }
    it 'should increase points' do
      expect(customer.points).to eq 0
      customer.add_points(20)
      expect(customer.points).to eq 20
      customer.add_points(5)
      expect(customer.points).to eq 25
    end
  end

  describe '.accept_invitation' do
    it { expect(customer.accepted).to be_falsey }

    it 'should change accepted' do
      customer.accept_invitation
      expect(customer.accepted).to be_truthy
    end
  end

  describe '.validate_recommended_by_points' do
    let(:customer) { described_class.new('A', nil, true) }
    let(:customer_two) { described_class.new('B', customer, true) }
    let(:customer_three) { described_class.new('C', customer_two, true) }
    let(:customer_four) { described_class.new('D', customer_three, true) }

    it 'should calculate rewards for all customers' do
      customer_four.validate_recommended_by_points
      expect(customer_four.points).to eq 0
      expect(customer_three.points).to eq 1.to_f
      expect(customer_two.points).to eq 1 / 2.to_f
      expect(customer.points).to eq 1 / 4.to_f
    end
  end

end