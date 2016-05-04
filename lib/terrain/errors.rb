module Terrain
  module Errors
    class Unauthenticated < StandardError; end
    class Unauthorized < StandardError; end

    extend ActiveSupport::Concern

    included do
      rescue_from Unauthenticated, with: :unauthenticated
      rescue_from Unauthorized, with: :unauthorized
      rescue_from 'ActiveRecord::RecordNotFound', with: :record_not_found
      rescue_from 'ActionController::RoutingError', with: :route_not_found
      rescue_from 'ActiveRecord::RecordInvalid', with: :record_invalid

      private

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

      def record_invalid
        error_response(:record_invalid, 422)
      end

      def error_response(key = :server_error, status = 500)
        result = {
          error: {
            key: key,
            message: I18n.t("terrain.errors.#{key}", request: request)
          }
        }

        render json: result, status: status
      end
    end
  end
end
