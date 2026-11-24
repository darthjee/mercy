# frozen_string_literal: true

module Mercy
  class Report
    class DummyReport < Report
      ALLOWED_PARAMETERS = %i[period threshold].freeze
      def initialize(options) # rubocop:disable Lint/MissingSuper
      end
    end
  end
end
