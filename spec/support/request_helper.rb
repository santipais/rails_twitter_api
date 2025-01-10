# frozen_string_literal: true

module RequestHelper
  def json
    response.parsed_body.deep_symbolize_keys
  end
end
