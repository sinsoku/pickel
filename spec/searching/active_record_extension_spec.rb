# frozen_string_literal: true

RSpec.describe Searching::ActiveRecordExtension do
  describe '#search' do
    subject { ActiveRecord::Base.public_methods(true) }

    it { is_expected.to include :searching }
  end
end
