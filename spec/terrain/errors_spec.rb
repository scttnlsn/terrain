require 'spec_helper'

describe 'Terrain::Errors', type: :controller do
  controller do
    include Terrain::Errors
  end

  before { get :index }

  context 'record not found' do
    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it { expect(response.status).to eq 404 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'record_not_found') }
  end

  context 'route not found' do
    controller do
      def index
        raise ActionController::RoutingError, ''
      end
    end

    it { expect(response.status).to eq 404 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'route_not_found') }
  end

  context 'unauthenticated' do
    controller do
      def index
        raise Terrain::Errors::Unauthenticated
      end
    end

    it { expect(response.status).to eq 401 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'unauthenticated') }
  end

  context 'unauthorized' do
    controller do
      def index
        raise Terrain::Errors::Unauthorized
      end
    end

    it { expect(response.status).to eq 403 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'unauthorized') }
  end
end
