# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

API_VERSION = 2

describe "Posts API v2" do
  describe '#index' do
    context 'with 3 posts' do
      let!(:user) { create(:user) }
      let!(:posts) { FactoryGirl.create_list(:post, 3, user: user) }
      before { get '/api/posts', headers: api_header(API_VERSION) }

      it 'returns all posts' do
        expect(json['data'].length).to eq(3)
      end

      it 'returns correct meta' do
        expect(json['meta']['total']).to eq(3)
      end
    end

    context 'with 3 sorted desc posts' do
      let!(:user) { create(:user) }
      let!(:posts) { FactoryGirl.create_list(:post, 3, user: user) }
      before do
        get '/api/posts', params: { sort_by: :created_at, sort_direction: :desc },
            headers: api_header(API_VERSION)
      end

      it 'returns all posts' do
        expect(json['data'].length).to eq(3)
      end

      it 'returns correct meta' do
        expect(json['meta']['total']).to eq(3)
      end

      it 'returns right ordered posts' do
        expect(
          json['data'].first['id'].to_i
        ).to eq(Post.sorted_by(:created_at, :desc).first.id)
      end
    end

    context 'with 3 sorted asc posts' do
      let!(:user) { create(:user) }
      let!(:posts) { FactoryGirl.create_list(:post, 3, user: user) }
      before do
        get '/api/posts', params: { sort_by: :created_at, sort_direction: :asc },
            headers: api_header(API_VERSION)
      end

      it 'returns all posts' do
        expect(json['data'].length).to eq(3)
      end

      it 'returns correct meta' do
        expect(json['meta']['total']).to eq(3)
      end

      it 'returns right ordered posts' do
        expect(
          json['data'].first['id'].to_i
        ).to eq(Post.sorted_by(:created_at, :asc).first.id)
      end
    end

    context 'with 3 posts (search)' do
      let!(:user) { create(:user) }
      let!(:posts) { FactoryGirl.create_list(:post, 3, user: user) }
      before do
        get '/api/posts', params: { search: "#{posts[1].title}" },
            headers: api_header(API_VERSION)
      end

      it 'returns only one post' do
        expect(json['data'].length).to eq(1)
      end

      it 'returns correct meta' do
        expect(json['meta']['total']).to eq(1)
      end

      it 'returns correct post' do
        expect(json['data'].first['id'].to_i).to eq(posts[1].id)
      end
    end

    context 'with 7 posts and default pagination settings' do
      let!(:user) { create(:user) }
      let!(:posts) { FactoryGirl.create_list(:post, 7, user: user) }

      it 'returns correct meta' do
        get '/api/posts', headers: api_header(API_VERSION)

        expect(json['meta']['total']).to eq(7)
      end

      it 'returns only first page posts' do
        get '/api/posts', headers: api_header(API_VERSION)

        expect(json['data'].length).to eq(5)
      end

      it 'returns correct page urls for the first page' do
        get '/api/posts?page[number]=1', headers: api_header(API_VERSION)

        links_hash(last: 'api/posts?page%5Bnumber%5D=2&page%5Bsize%5D=5',
                   next: 'api/posts?page%5Bnumber%5D=2&page%5Bsize%5D=5')

        links_hash['links'].each_key do |key|
          expect(json['links'][key.to_s]).to include(links_hash[key])
        end
      end

      it 'returns correct page urls for the first page' do
        get '/api/posts?page[number]=2', headers: api_header(API_VERSION)

        links_hash(last: 'api/posts?page%5Bnumber%5D=2&page%5Bsize%5D=5',
                   next: 'api/posts?page%5Bnumber%5D=2&page%5Bsize%5D=5',
                   first: 'api/posts?page%5Bnumber%5D=1&page%5Bsize%5D=5',
                   prev: 'api/posts?page%5Bnumber%5D=1&page%5Bsize%5D=5',
                   self: 'api/posts?page%5Bnumber%5D=2&page%5Bsize%5D=5')

        links_hash['links'].each_key do |key|
          expect(json['links'][key.to_s]).to include(links_hash[key])
        end
      end

      it 'returns only first page posts' do
        get '/api/posts?page[number]=2', headers: api_header(API_VERSION)

        expect(json['data'].length).to eq(2)
      end
    end

    context 'with empty posts' do
      before { get '/api/posts', headers: api_header(API_VERSION) }

      it 'returns correct meta' do
        expect(json['meta']['total']).to eq(0)
      end

      it 'returns empty array' do
        expect(json['data'].length).to eq(0)
      end
    end
  end

  describe '#show' do
    context 'with 1 post' do
      let!(:post) { create(:post) }
      before do
        get "/api/posts/#{post.id}", headers: api_header(API_VERSION)
      end

      it 'returns correct data' do
        expect(json['data']).to eq(post_v2_hash(post))
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
    context 'with provided attributes without image' do
      let(:user) { create(:user) }
      let!(:post_attrs) { FactoryGirl.attributes_for(:post) }
      let!(:headers) { api_auth_headers(user.id, 2) }
      before do
        travel_to Time.current
        post '/api/posts', headers: headers, params: { post: post_attrs }
      end

      after { travel_back }

      it 'returns 201 as status code' do
        expect(response.status).to eq(201)
      end

      it 'returns correct data' do
        expect(json['data']).to eq(post_v2_hash(Post.last))
      end
    end

    context 'with provided attributes with image' do
      let(:user) { create(:user) }
      let!(:post_attrs) { FactoryGirl.attributes_for(:post_with_image) }
      let!(:headers) { api_auth_headers(user.id, 2) }
      before do
        travel_to Time.current
        post '/api/posts', headers: headers, params: { post: post_attrs }
      end

      after { travel_back }

      it 'returns 201 as status code' do
        expect(response.status).to eq(201)
      end

      it 'returns correct data' do
        expect(json['data']).to eq(post_v2_hash(Post.last))
      end
    end

    context 'with empty title' do
      let(:user) { create(:user) }
      let!(:headers) { api_auth_headers(user.id, 2) }
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
    let!(:post) { create(:post_with_image) }
    let!(:headers) { api_auth_headers(post.user_id, API_VERSION) }

    context 'with provided attributes' do
      let!(:new_post_attrs) do
        FactoryGirl.attributes_for(:post_with_jpeg_image, user_id: post.user_id)
      end
      before do
        put "/api/posts/#{post.id}", headers: headers,
            params: { post: new_post_attrs }
      end

      before(:all) { travel_to Time.current }
      after(:all) { travel_back }

      it 'returns correct data' do
        expect(json['data']).to eq(post_v2_hash(post, new_post_attrs))
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
      let!(:headers) { api_auth_headers(post.user_id, API_VERSION) }
      before { delete "/api/posts/#{post.id}", headers: headers }

      it 'returns 200 as status code' do
        expect(response.status).to eq(200)
      end

      it 'returns empty JSON' do
        expect(json).to eq({})
      end

      it 'really removes post' do
        expect(Post.find_by(id: post.id)).to eq(nil)
      end
    end

    context 'without existed post' do
      let!(:user) { create(:user) }
      let!(:headers) { api_auth_headers(user.id, 2)  }
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
      before { delete "/api/posts/#{post.id}", headers: api_header(API_VERSION) }

      it 'returns 401 as status code' do
        expect(response.status).to eq(401)
      end
    end
  end
end

def post_v2_hash(post, new_attrs = {})
  {
    'id' => post.id.to_s,
    'type' => 'posts',
    'attributes' => {
      'title' => new_attrs[:title].blank? ? post.title : new_attrs[:title].to_s,
      'body' => new_attrs[:body].blank? ? post.body : new_attrs[:body].to_s,
      'image' => {
        'url' => new_attrs[:image].blank? ? post.image.url : image_link(post, new_attrs[:image])
      },
      'user-id' => new_attrs[:user_id].blank? ? post.user_id : new_attrs[:user_id].to_i,
      'created-at' => json_api_date(post.created_at),
      'updated-at' => json_api_date(post.updated_at)
    },
    'links' => {
      'self' => "/api/posts/#{post.id}"
    }
  }
end

def links_hash(attrs = {})
  hash = {
    'links' => {}
  }
  attrs.keys.each do |key|
    hash['links'][key.to_s] = attrs[key.to_sym]
  end
  hash
end

def image_link(post, image)
  "/uploads/test/post/image/#{post.id}/#{image.original_filename}"
end
