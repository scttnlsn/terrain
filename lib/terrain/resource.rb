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
        render json: create_record, status: 201
      end

      def update
        render json: update_record(load_record)
      end

      private

      def resource
        self.class.instance_variable_get('@resource')
      end

      def permitted_params
        params.permit(*self.class.permit)
      end

      def load_record
        resource.find(params[:id])
      end

      def create_record
        resource.create!(permitted_params)
      end

      def update_record(record)
        record.update_attributes!(permitted_params)
        record
      end
    end
  end
end
