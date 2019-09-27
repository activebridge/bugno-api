RSpec::Matchers.define :respond_with_status do |status|
  match do |subject|
    subject.call
    status == response.response_code
  end

  failure_message do |_|
    "expected to respond with status #{status} but was #{response.response_code}"
  end
end
