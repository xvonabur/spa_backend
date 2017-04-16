# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

API_VERSION = 2

describe "Users API v2" do
  describe '#show' do
    context 'with 1 user' do
      let!(:user) { create(:user) }
      before do
        get "/api/users/#{user.id}", headers: api_header(API_VERSION)
      end

      it 'returns correct data' do
        expect(json['data']).to eq(user_v2_hash(user))
      end

      context 'with no users' do
        before { get '/api/users/1', headers: api_header(API_VERSION) }

        it 'returns 404 as status code' do
          expect(response.status).to eq(404)
        end

        it 'returns empty JSON' do
          expect(json).to eq({})
        end
      end
    end
  end

  describe '#update' do
    let!(:user) { create(:user) }
    let!(:headers) { api_auth_headers(user.id, API_VERSION) }

    context 'with provided attributes' do
      let!(:new_user_attrs) do
        FactoryGirl.attributes_for(:user, locale: 'eng')
      end
      before do
        put "/api/users/#{user.id}", headers: headers,
            params: { user: new_user_attrs }
      end

      before(:all) { travel_to Time.current }
      after(:all) { travel_back }

      it 'returns correct data' do
        expect(json['data']).to eq(user_v2_hash(user, new_user_attrs))
      end
    end

    context 'unauthorized' do
      let!(:new_user_attrs) do
        FactoryGirl.attributes_for(:user)
      end
      before { put "/api/users/#{user.id}", params: { user: new_user_attrs },
                   headers: api_header(API_VERSION)
      }

      it 'returns 401 as status code' do
        expect(response.status).to eq(401)
      end
    end
  end
end

def user_v2_hash(user, new_attrs = {})
  {
    'id' => user.id.to_s,
    'type' => 'users',
    'attributes' => {
      'email' => new_attrs[:email].blank? ? user.email : new_attrs[:email].to_s,
      'locale' => new_attrs[:locale].blank? ? user.locale : new_attrs[:locale].to_s,
      'created-at' => json_api_date(user.created_at),
      'updated-at' => json_api_date(user.updated_at)
    },
    'links' => {
      'self' => "/api/users/#{user.id}"
    }
  }
end
