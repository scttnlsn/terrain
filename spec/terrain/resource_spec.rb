require 'spec_helper'

describe 'Terrain::Resource', type: :controller do
  controller do
    include Terrain::Resource

    resource Example, permit: [:foo, :bar, :baz]
  end

  describe '#index' do
    let!(:examples) { create_list(:example, 10) }

    it 'responds with 200 status' do
      get :index
      expect(response.status).to eq 200
    end

    it 'responds with serialized records' do
      get :index
      expect(response.body).to eq serialize(Example.all).to_json
    end
  end

  describe '#create' do
    let(:params) { ActionController::Parameters.new(attributes_for(:example)) }

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
      let(:params) { ActionController::Parameters.new(attributes_for(:example, foo: nil)) }

      it 'raises error' do
        expect { post :create, params }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'with failing policy' do
      before do
        allow_any_instance_of(Example).to receive(:policy_class) { policy_double(create?: false) }
      end

      it 'raises error' do
        expect { post :create, params }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe '#show' do
    let!(:record) { create(:example) }
    let(:params) { ActionController::Parameters.new(id: record.id) }

    it 'responds with 200 status' do
      get :show, params
      expect(response.status).to eq 200
    end

    it 'responds with serialized record' do
      get :show, params
      expect(response.body).to eq serialize(record).to_json
    end

    context 'invalid ID' do
      let(:params) { ActionController::Parameters.new(id: 999) }

      it 'raises error' do
        expect { get :show, params }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with failing policy' do
      before do
        allow_any_instance_of(Example).to receive(:policy_class) { policy_double(show?: false) }
      end

      it 'raises error' do
        expect { get :show, params }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context 'with relations' do
      let!(:widgets) { create_list(:widget, 3, example: record) }

      it 'does not include relations in serialized record' do
        get :show, params
        expect(response.body).to eq serialize(record, include: []).to_json
      end

      context 'with valid include' do
        let(:params) { ActionController::Parameters.new(id: record.id, include: 'widgets') }

        it 'includes relations in serialized record' do
          get :show, params
          expect(response.body).to eq serialize(record, include: ['widgets']).to_json
        end
      end

      context 'with invalid include' do
        let(:params) { ActionController::Parameters.new(id: record.id, include: 'widgets,wrong') }

        it 'raises error' do
          expect { get :show, params }.to raise_error ActiveRecord::AssociationNotFoundError
        end
      end
    end
  end

  describe '#update' do
    let!(:record) { create(:example) }
    let(:attrs) { attributes_for(:example) }
    let(:params) { ActionController::Parameters.new(attrs.merge(id: record.id)) }

    it 'responds with 200 status' do
      patch :update, params
      expect(response.status).to eq 200
    end

    it 'updates record' do
      patch :update, params
      record.reload
      expect(record.foo).to eq params[:foo]
      expect(record.bar).to eq params[:bar]
      expect(record.baz).to eq params[:baz]
    end

    it 'responds with serialized record' do
      patch :update, params
      expect(response.body).to eq serialize(record.reload).to_json
    end

    context 'invalid params' do
      let(:attrs) { attributes_for(:example, foo: nil) }

      it 'raises error' do
        expect { patch :update, params }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'invalid ID' do
      let(:params) { ActionController::Parameters.new(id: 999) }

      it 'raises error' do
        expect { patch :update, params }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with failing policy' do
      before do
        allow_any_instance_of(Example).to receive(:policy_class) { policy_double(update?: false) }
      end

      it 'raises error' do
        expect { patch :update, params }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe '#destroy' do
    let!(:record) { create(:example) }
    let(:params) { ActionController::Parameters.new(id: record.id) }

    it 'responds with 204 status' do
      delete :destroy, params
      expect(response.status).to eq 204
    end

    it 'deletes record' do
      expect { delete :destroy, params }.to change { Example.count }.by -1
    end

    context 'invalid ID' do
      let(:params) { ActionController::Parameters.new(id: 999) }

      it 'raises error' do
        expect { patch :update, params }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with failing policy' do
      before do
        allow_any_instance_of(Example).to receive(:policy_class) { policy_double(destroy?: false) }
      end

      it 'raises error' do
        expect { delete :destroy, params }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end
end
