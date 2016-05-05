require 'terrain/page'

module Terrain
  module Errors
    extend ActiveSupport::Concern

    included do
      rescue_from 'ActiveRecord::AssociationNotFoundError', with: :association_not_found
      rescue_from 'Pundit::NotAuthorizedError', with: :unauthorized
      rescue_from 'ActiveRecord::RecordNotFound', with: :record_not_found
      rescue_from 'ActionController::RoutingError', with: :route_not_found
      rescue_from 'ActiveRecord::RecordInvalid', with: :record_invalid

      rescue_from Terrain::Page::RangeError, with: :range_error

      private

      def error_response(key = :server_error, status = 500, details = nil)
        result = {
          error: {
            key: key,
            message: I18n.t("terrain.errors.#{key}", request: request)
          }
        }

        if details.present?
          result[:error][:details] = details
        end

        render json: result, status: status
      end

      def association_not_found
        error_response(:association_not_found, 400)
      end

      def unauthenticated
        error_response(:unauthenticated, 401)
      end

      def unauthorized
        error_response(:unauthorized, 403)
      end

      def record_not_found
        error_response(:record_not_found, 404)
      end

      def route_not_found
        error_response(:route_not_found, 404)
      end

      def record_invalid(error)
        error_response(:record_invalid, 422, error.record.errors.to_hash)
      end

      def range_error
        error_response(:range_error, 416)
      end
    end
  end
end
