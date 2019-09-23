RSpec::Matchers.define :respond_with_status do |status|
  match do |subject|
    subject.call
    status == response.response_code
  end
end
