RSpec.shared_examples 'api_version' do |version_number|
  context "GET /api/v#{version_number}/version" do
    subject do
      get "/api/v#{version_number}/version"
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end
