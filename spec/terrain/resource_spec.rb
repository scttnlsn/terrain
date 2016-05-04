require 'spec_helper'

describe 'Terrain::Resource', type: :controller do
  controller do
    include Terrain::Resource

    resource Example, permit: [:foo, :bar, :baz]
  end

  describe '#create' do
    let(:params) { attributes_for(:example) }

    it 'responds with 201 status' do
      post :create, params
      expect(response.status).to eq 201
    end

    it 'creates record' do
      expect { post :create, params }.to change { Example.count }.by 1
    end

    it 'responds with serialized record' do
      post :create, params
      expect(response.body).to eq serialize(Example.last).to_json
    end

    context 'invalid params' do
      let(:params) { attributes_for(:example, foo: nil) }

      it 'raises error' do
        expect { post :create, params }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
