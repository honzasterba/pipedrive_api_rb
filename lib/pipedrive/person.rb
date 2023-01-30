# frozen_string_literal: true

module Pipedrive
  class Person < Base
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete
    include ::Pipedrive::Utils

    def search(*args, &block)
      params = args.extract_options!
      params[:term] ||= args[0]
      raise 'term is missing' unless params[:term]

      params[:fields] ||= args[1]
      return to_enum(:find_by_name, params) unless block_given?

      follow_pagination(:make_api_call, [:get, 'search'], params, &block)
    end
  end
end
