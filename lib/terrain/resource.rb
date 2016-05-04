module Terrain
  module Resource
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :permit

      def resource(resource, options = {})
        @resource = resource

        self.permit = options[:permit] || []
      end
    end

    included do
      def create
        record = resource.create!(permitted_params)
        render json: record, status: 201
      end

      private

      def resource
        self.class.instance_variable_get('@resource')
      end

      def permitted_params
        params.permit(*self.class.permit)
      end
    end
  end
end
