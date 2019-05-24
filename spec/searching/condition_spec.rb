# frozen_string_literal: true

RSpec.describe Searching::Condition do
  describe '.for' do
    let(:condition) { Searching::Condition.for(User, :posts_comments_id_eq) }

    it 'generates a condition through relations' do
      expect(condition.klass).to eq User
      expect(condition.predicate.id).to eq :eq
      expect(condition.column).to eq 'id'
      expect(condition.target).to eq Comment
      expect(condition.join_tables).to eq [:posts, :comments]
    end
  end
end
