# frozen_string_literal: true

RSpec.describe Searching::Predicate do
  describe '.find' do
    context 'pass name_in' do
      let(:predicate) { described_class.find('name_in') }

      it { expect(predicate.id).to eq :in }
    end

    context 'pass name_not_in' do
      let(:predicate) { described_class.find('name_not_in') }

      it { expect(predicate.id).to eq :not_in }
    end
  end
end
