# frozen_string_literal: true
require 'rails_helper'

describe Post, type: :model do
  context 'created_at sorting' do
    let(:user) { create(:user) }
    let!(:posts) { FactoryGirl.create_list(:post, 3, user: user) }

    context 'ASC' do
      it 'returns correct first post' do
        sorted = described_class.sorted_by(:created_at, :asc)

        expect(sorted.first).to eq(posts.first)
      end

      it 'returns correct last post' do
        sorted = described_class.sorted_by(:created_at, :asc)

        expect(sorted.last).to eq(posts.last)
      end

      it 'returns correct post number' do
        sorted = described_class.sorted_by(:created_at, :asc)

        expect(sorted.size).to eq(posts.size)
      end
    end

    context 'DESC' do
      it 'returns correct first post' do
        sorted = described_class.sorted_by(:created_at, :desc)

        expect(sorted.first).to eq(posts.last)
      end

      it 'returns correct last post' do
        sorted = described_class.sorted_by(:created_at, :desc)

        expect(sorted.last).to eq(posts.first)
      end

      it 'returns correct post number' do
        sorted = described_class.sorted_by(:created_at, :desc)

        expect(sorted.size).to eq(posts.size)
      end
    end

    context 'searching' do
      let(:user) { create(:user) }
      let!(:titles) do
        ['Super useful post!', 'What a terrible post!', 'Life hacks all the way!']
      end
      before { titles.each { |title| create(:post, user: user, title: title) } }

      context 'by title' do
        it 'returns correct post number' do
          filtered = described_class.search_by_title('post!')

          expect(filtered.size).to eq(2)
        end
      end
    end
  end
end
