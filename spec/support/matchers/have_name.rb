RSpec::Matchers.define :have_name do |key|
  chain :with_value do |value|
    @with_value = true
    @value = value
  end

  match do |hash|
    expected = @with_value ? { key => @value } : key
    expect(hash).to include expected
  end
end
