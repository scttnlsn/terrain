require 'spec_helper'

describe 'Terrain::Errors', type: :controller do
  controller do
    include Terrain::Errors
  end

  before { get :index }

  context 'association not found' do
    controller do
      def index
        raise ActiveRecord::AssociationNotFoundError.new(nil, nil)
      end
    end

    it { expect(response.status).to eq 400 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'association_not_found') }
  end

  context 'unauthorized' do
    controller do
      def index
        raise Pundit::NotAuthorizedError
      end
    end

    it { expect(response.status).to eq 403 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'unauthorized') }
  end

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

  context 'range error' do
    controller do
      def index
        raise Terrain::Page::RangeError
      end
    end

    it { expect(response.status).to eq 416 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'range_error') }
  end

  context 'record invalid' do
    controller do
      def index
        raise ActiveRecord::RecordInvalid, Example.new
      end
    end

    it { expect(response.status).to eq 422 }
    it { expect_json_types(error: :object) }
    it { expect_json_types('error.message', :string) }
    it { expect_json('error.key', 'record_invalid') }
  end
end
