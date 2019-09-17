RSpec.shared_examples 'api_version' do |version_number|
  context "GET /api/v#{version_number}/version" do
    subject { -> { get "/api/v#{version_number}/version" } }

    it { is_expected.to respond_with_status(200) }
  end
end
