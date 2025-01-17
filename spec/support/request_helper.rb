# frozen_string_literal: true

module RequestHelper
  def json
    body = response.parsed_body
    if body.is_a?(Array)
      body.map(&:deep_symbolize_keys)
    else
      body.deep_symbolize_keys
    end
  end
end
