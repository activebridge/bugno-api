RSpec::Matchers.define :respond_with_json_count do |expected|
  chain :at do |field|
    @with_at = true
    @field = field
  end

  match do |subject|
    subject.call
    json = JSON.parse(response.body, symbolize_names: true)
    @result = @with_at ? json[@field] : json
    expect(@result.size).to eq(expected)
  end

  failure_message do |_|
    return "expected to be #{expected} at #{@field} but was #{@result.size}" if @with_at
    "expected to be #{expected} but was #{@result.size}"
  end
end
