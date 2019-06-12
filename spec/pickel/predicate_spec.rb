# frozen_string_literal: true

RSpec.describe Pickel::Predicate do
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

  describe '#build' do
    it 'builds a query using :eq' do
      predicate = Pickel::Predicate.new(:eq)
      sql = predicate.build(User, 'name', 'foo').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE "users"."name" = \'foo\''
    end

    it 'builds a query using :not_eq' do
      predicate = Pickel::Predicate.new(:not_eq)
      sql = predicate.build(User, 'name', 'foo').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE "users"."name" != \'foo\''
    end

    it 'builds a query using :gt' do
      predicate = Pickel::Predicate.new(:gt)
      sql = predicate.build(User, 'age', '10').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE "users"."age" > 10'
    end

    it 'builds a query using :cont' do
      predicate = Pickel::Predicate.new(:cont)
      sql = predicate.build(User, 'name', 'foo').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE "users"."name" LIKE \'%foo%\''
    end

    it 'builds a query using :not_cont' do
      predicate = Pickel::Predicate.new(:not_cont)
      sql = predicate.build(User, 'name', 'foo').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE NOT ("users"."name" LIKE \'%foo%\')'
    end

    it 'builds a query using :true' do
      predicate = Pickel::Predicate.new(:true)
      sql = predicate.build(User, 'paid', '1').to_sql

      expect(sql).to eq User.where(paid: true).to_sql
    end

    it 'builds a query using :true and falsy value' do
      predicate = Pickel::Predicate.new(:true)
      sql = predicate.build(User, 'paid', '0').to_sql

      expect(sql).to eq User.where.not(paid: true).to_sql
    end

    it 'builds a query using :false' do
      predicate = Pickel::Predicate.new(:false)
      sql = predicate.build(User, 'paid', '1').to_sql

      expect(sql).to eq User.where(paid: false).to_sql
    end

    it 'builds a query using :false and falsy value' do
      predicate = Pickel::Predicate.new(:false)
      sql = predicate.build(User, 'paid', '0').to_sql

      expect(sql).to eq User.where.not(paid: false).to_sql
    end

    it 'builds a query using :blank' do
      predicate = Pickel::Predicate.new(:blank)
      sql = predicate.build(User, 'name', '1').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE ("users"."name" IS NULL OR "users"."name" = \'\')'
    end

    it 'builds a query using :blank and falsy value' do
      predicate = Pickel::Predicate.new(:blank)
      sql = predicate.build(User, 'name', '0').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE NOT (("users"."name" IS NULL OR "users"."name" = \'\'))'
    end

    it 'builds a query using :present' do
      predicate = Pickel::Predicate.new(:present)
      sql = predicate.build(User, 'name', '1').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE ("users"."name" IS NOT NULL AND "users"."name" != \'\')'
    end

    it 'builds a query using :present and falsy value' do
      predicate = Pickel::Predicate.new(:present)
      sql = predicate.build(User, 'name', '0').to_sql

      expect(sql).to eq 'SELECT "users".* FROM "users" WHERE NOT (("users"."name" IS NOT NULL AND "users"."name" != \'\'))'
    end
  end
end
