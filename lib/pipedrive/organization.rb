# frozen_string_literal: true

module Pipedrive
  class Organization < Base
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete
    include ::Pipedrive::Utils

    def search(*args, &block)
      params = args.extract_options!
      params[:term] ||= args[0]
      raise 'term is missing' unless params[:term]

      return to_enum(:search, params) unless block

      follow_pagination(:make_api_call, [:get, 'search'], params, &block)
    end
  end
end
