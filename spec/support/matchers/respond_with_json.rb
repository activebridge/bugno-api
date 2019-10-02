RSpec::Matchers.define :respond_with_json do |expected, field|
  match do |subject|
    subject.call
    json = JSON.parse(response.body, symbolize_names: true)
    @result = field.present? ? json[field] : json
    return expect(@result).to eq(expected) unless expected.is_a?(Hash)

    expect(@result).to include(expected)
  end

  failure_message do |_|
    return "expected #{@result} to eq #{expected}" unless expected.is_a?(Hash)

    "expected #{@result} to include #{expected}"
  end
end
