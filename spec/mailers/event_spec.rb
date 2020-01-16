# frozen_string_literal: true

describe EventMailer do
  let(:event) { create(:event) }
  let(:mail) { EventMailer.exception(event) }

  it 'renders the headers' do
    expect(mail.subject).to eq("[#{event.project.name}] #{event.environment}:"\
                               " #{event.title} has occured. #{event.message}")
  end

  it { expect(mail.body.encoded).to match(event.message) }
end
