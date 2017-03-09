# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe "Posts API" do
  describe '#index' do
    context 'with 3 posts' do
      let!(:posts) { FactoryGirl.create_list(:post, 3) }
      before { get '/api/posts' }

      it 'returns 200 as status code' do
        expect(response).to be_success
      end

      it 'returns all posts' do
        expect(json['data'].length).to eq(3)
      end
    end

    context 'with empty posts' do
      before { get '/api/posts' }

      it 'returns 200 as status code' do
        expect(response).to be_success
      end

      it 'returns empty array' do
        expect(json['data'].length).to eq(0)
      end
    end
  end

  describe '#show' do
    context 'with 1 post' do
      let!(:post) { create(:post) }
      before { get "/api/posts/#{post.id}" }

      it 'returns 200 as status code' do
        expect(response).to be_success
      end

      it 'returns correct id' do
        expect(json['data']['id']).to eq(post.id.to_s)
      end

      it 'returns correct type' do
        expect(json['data']['type']).to eq('posts')
      end

      it 'returns correct title' do
        expect(json['data']['attributes']['title']).to eq(post.title)
      end

      it 'returns correct body' do
        expect(json['data']['attributes']['body']).to eq(post.body)
      end

      it 'returns correct username' do
        expect(json['data']['attributes']['username']).to eq(post.username)
      end

      it 'returns correct created_at' do
        expect(
          json['data']['attributes']['created-at']
        ).to eq(json_api_date(post.created_at))
      end

      it 'returns correct updated_at' do
        expect(
          json['data']['attributes']['updated-at']
        ).to eq(json_api_date(post.updated_at))
      end

      it 'returns correct link' do
        expect(json['data']['links']['self']).to eq("/api/posts/#{post.id}")
      end

      context 'with no posts' do
        before { get '/api/posts/1' }

        it 'returns 404 as status code' do
          expect(response.status).to eq(404)
        end

        it 'returns empty JSON' do
          expect(json).to eq({})
        end
      end
    end
  end

  describe '#create' do
    context 'with provided attributes' do
      let!(:post_attrs) { FactoryGirl.attributes_for(:post) }
      before do
        travel_to Time.current
        post '/api/posts', params: { post: post_attrs }
      end

      after { travel_back }

      it 'returns 201 as status code' do
        expect(response.status).to eq(201)
      end

      it 'returns correct id' do
        expect(json['data']['id'].to_i).to be > 0
      end

      it 'returns correct type' do
        expect(json['data']['type']).to eq('posts')
      end

      it 'returns correct title' do
        expect(json['data']['attributes']['title']).to eq(post_attrs[:title])
      end

      it 'returns correct body' do
        expect(json['data']['attributes']['body']).to eq(post_attrs[:body])
      end

      it 'returns correct username' do
        expect(json['data']['attributes']['username']).to eq(post_attrs[:username])
      end

      it 'returns correct created_at' do
        expect(
          json['data']['attributes']['created-at']
        ).to eq(json_api_date(Time.current))
      end

      it 'returns correct updated_at' do
        expect(
          json['data']['attributes']['updated-at']
        ).to eq(json_api_date(Time.current))
      end

      it 'returns correct link' do
        expect(json['data']['links']['self']).to match("/api/posts/")
      end
    end

    context 'with empty title' do
      before do
        post '/api/posts', params: { post: { title: nil } }
      end

      it 'returns 422 as status code' do
        expect(response.status).to eq(422)
      end

      it 'returns error' do
        post = build(:post, title: nil)
        post.validate

        expect(json).to eq(post.errors.messages.as_json)
      end
    end
  end

  describe '#update' do
    let!(:post) { create(:post) }

    context 'with provided attributes' do
      let!(:new_post_attrs) { FactoryGirl.attributes_for(:post) }
      before do
        travel_to Time.current
        put "/api/posts/#{post.id}", params: { post: new_post_attrs }
      end

      after { travel_back }

      it 'returns 200 as status code' do
        expect(response.status).to eq(200)
      end

      it 'returns correct id' do
        expect(json['data']['id'].to_i).to be > 0
      end

      it 'returns correct type' do
        expect(json['data']['type']).to eq('posts')
      end

      it 'returns correct title' do
        expect(json['data']['attributes']['title']).to eq(new_post_attrs[:title])
      end

      it 'returns correct body' do
        expect(json['data']['attributes']['body']).to eq(new_post_attrs[:body])
      end

      it 'returns correct username' do
        expect(
          json['data']['attributes']['username']
        ).to eq(new_post_attrs[:username])
      end

      it 'returns correct created_at' do
        expect(
          json['data']['attributes']['created-at']
        ).to eq(json_api_date(post.created_at))
      end

      it 'returns correct updated_at' do
        expect(
          json['data']['attributes']['updated-at']
        ).to eq(json_api_date(Time.current))
      end

      it 'returns correct link' do
        expect(json['data']['links']['self']).to eq("/api/posts/#{post.id}")
      end
    end

    context 'with empty title' do
      before do
        put "/api/posts/#{post.id}", params: { post: { title: nil } }
      end

      it 'returns 422 as status code' do
        expect(response.status).to eq(422)
      end

      it 'returns error' do
        post = build(:post, title: nil)
        post.validate

        expect(json).to eq(post.errors.messages.as_json)
      end
    end
  end

  describe '#destroy' do
    context 'with existed post' do
      let!(:post) { create(:post) }
      before { delete "/api/posts/#{post.id}" }

      it 'returns 200 as status code' do
        expect(response.status).to eq(200)
      end

      it 'returns empty JSON' do
        expect(json).to eq({})
      end
    end

    context 'without existed post' do
      before { delete '/api/posts/1' }

      it 'returns 404 as status code' do
        expect(response.status).to eq(404)
      end

      it 'returns empty JSON' do
        expect(json).to eq({})
      end
    end
  end
end
