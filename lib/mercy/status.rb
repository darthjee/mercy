# frozen_string_literal: true

module Mercy
  class Status
    attr_reader :reports

    def initialize(reports)
      @reports = reports
    end

    def status
      reports.any?(&:error?) ? :error : :ok
    end

    def http_status
      status == :ok ? :ok : :internal_server_error
    end

    def as_json
      {
        status: status
      }.merge(reports_jsons)
    end

    private

    def reports_jsons
      reports.map(&:as_json).as_hash(reports.map(&:id))
    end
  end
end
