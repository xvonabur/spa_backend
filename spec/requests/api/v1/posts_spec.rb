# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe "Posts API" do
  describe '#index' do
    context 'with 3 posts' do
      let!(:user) { create(:user) }
      let!(:posts) { FactoryGirl.create_list(:post, 3, user: user) }
      before { get '/api/posts' }

      it 'returns all posts' do
        expect(json['data'].length).to eq(3)
      end
    end

    context 'with empty posts' do
      before { get '/api/posts' }

      it 'returns empty array' do
        expect(json['data'].length).to eq(0)
      end
    end
  end

  describe '#show' do
    context 'with 1 post' do
      let!(:post) { create(:post) }
      before do
        get "/api/posts/#{post.id}"
      end

      it 'returns correct data' do
        expect(json['data']).to eq(post_v1_hash(post))
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
      let(:user) { create(:user) }
      let!(:post_attrs) { FactoryGirl.attributes_for(:post) }
      let!(:headers) { auth_header_for_user(user.id) }
      before do
        travel_to Time.current
        post '/api/posts', headers: headers, params: { post: post_attrs }
      end

      after { travel_back }

      it 'returns 201 as status code' do
        expect(response.status).to eq(201)
      end

      it 'returns correct data' do
        expect(json['data']).to eq(post_v1_hash(Post.last))
      end
    end

    context 'with empty title' do
      let(:user) { create(:user) }
      let!(:headers) { auth_header_for_user(user.id) }
      before do
        post '/api/posts', headers: headers, params: { post: { title: nil } }
      end

      it 'returns 422 as status code' do
        expect(response.status).to eq(422)
      end

      it 'returns error' do
        post = build(:post, user: user, title: nil)
        post.validate

        expect(json).to eq(post.errors.messages.as_json)
      end
    end

    context 'unauthorized' do
      let!(:post_attrs) { FactoryGirl.attributes_for(:post) }
      before do
        post '/api/posts', params: { post: post_attrs }
      end

      it 'returns 401 as status code' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe '#update' do
    let!(:post) { create(:post) }
    let!(:headers) { auth_header_for_user(post.user_id) }

    context 'with provided attributes' do
      let!(:new_post_attrs) do
        FactoryGirl.attributes_for(:post, user_id: post.user_id)
      end
      before do
        travel_to Time.current
        put "/api/posts/#{post.id}", headers: headers,
            params: { post: new_post_attrs }
      end

      after { travel_back }

      it 'returns correct data' do
        expect(json['data']).to eq(post_v1_hash(Post.last, new_post_attrs))
      end
    end

    context 'with empty title' do
      before do
        put "/api/posts/#{post.id}", headers: headers,
            params: { post: { title: nil } }
      end

      it 'returns 422 as status code' do
        expect(response.status).to eq(422)
      end

      it 'returns error' do
        new_post = build(:post, user: post.user, title: nil)
        new_post.validate

        expect(json).to eq(new_post.errors.messages.as_json)
      end
    end

    context 'unauthorized' do
      let!(:new_post_attrs) do
        FactoryGirl.attributes_for(:post, user_id: post.user_id)
      end
      before { put "/api/posts/#{post.id}", params: { post: new_post_attrs } }

      it 'returns 401 as status code' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe '#destroy' do
    context 'with existed post' do
      let!(:post) { create(:post) }
      let!(:headers) { auth_header_for_user(post.user_id) }
      before { delete "/api/posts/#{post.id}", headers: headers }

      it 'returns empty JSON' do
        expect(json).to eq({})
      end

      it 'really removes post' do
        expect(Post.find_by(id: post.id)).to eq(nil)
      end
    end

    context 'without existed post' do
      let!(:user) { create(:user) }
      let!(:headers) { auth_header_for_user(user.id)  }
      before { delete '/api/posts/1', headers: headers }

      it 'returns 404 as status code' do
        expect(response.status).to eq(404)
      end

      it 'returns empty JSON' do
        expect(json).to eq({})
      end
    end

    context 'unauthorized' do
      let!(:post) { create(:post) }
      before { delete "/api/posts/#{post.id}" }

      it 'returns 401 as status code' do
        expect(response.status).to eq(401)
      end
    end
  end
end

def post_v1_hash(post, new_attrs = {})
  {
    'id' => post.id.to_s,
    'type' => 'posts',
    'attributes' => {
      'title' => new_attrs[:title].blank? ? post.title : new_attrs[:title].to_s,
      'body' => new_attrs[:body].blank? ? post.body : new_attrs[:body].to_s,
      'user-id' => new_attrs[:user_id].blank? ? post.user_id : new_attrs[:user_id].to_i,
      'created-at' => json_api_date(post.created_at),
      'updated-at' => json_api_date(post.updated_at)
    },
    'links' => {
      'self' => "/api/posts/#{post.id}"
    }
  }
end
