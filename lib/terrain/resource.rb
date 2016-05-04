require 'pundit'

module Terrain
  module Resource
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :permit

      def resource(resource, options = {})
        include Pundit
        include Actions

        @resource = resource
        self.permit = options[:permit] || []
      end
    end

    module Actions
      def create
        record = resource.new(permitted_params)
        authorize_record(record)

        render json: create_record, include: [], status: 201
      end

      def show
        record = load_record
        authorize_record(record)

        render json: record, include: params[:include] || []
      end

      def update
        record = load_record
        authorize_record(record)

        render json: update_record(record), include: []
      end

      def destroy
        record = load_record
        authorize_record(record)
        destroy_record(record)

        render nothing: true, status: 204
      end

      private

      def resource
        self.class.instance_variable_get('@resource')
      end

      def includes_hash
        if params[:include].present?
          ActiveModel::Serializer::IncludeTree::Parsing.include_string_to_hash(params[:include])
        else
          {}
        end
      end

      def preloaded_resource
        resource.includes(includes_hash)
      end

      def permitted_params
        params.permit(*self.class.permit)
      end

      def pundit_user
        if defined?(current_user)
          current_user
        else
          nil
        end
      end

      def authorize_record(record)
        finder = Pundit::PolicyFinder.new(record)
        if finder.policy
          authorize(record)
        end
      end

      # These methods are indended to be overridden
      # if additional functionality is needed.

      def load_record
        preloaded_resource.find(params[:id])
      end

      def create_record
        resource.create!(permitted_params)
      end

      def update_record(record)
        record.update_attributes!(permitted_params)
        record
      end

      def destroy_record(record)
        record.delete
      end
    end
  end
end
