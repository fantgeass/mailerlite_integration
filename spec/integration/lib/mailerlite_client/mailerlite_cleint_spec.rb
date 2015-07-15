require 'rails_helper'

RSpec.describe MailerliteClient, type: :integration do
  subject { described_class.new('857fc1179eec42a46304c59dc3dbe1de') }
  before(:each) do
    WebMock.allow_net_connect!
  end
  after(:each) do
    WebMock.disable_net_connect!
  end

  describe '#campaigns' do
    context 'when api key is valid' do
      it do
        response = subject.campaigns

        expect(response.status).to be 200
      end
    end
    context 'when api key is invalid' do
      it do
        client = described_class.new('invalid-api-key')

        expect { client.campaigns }.to raise_error(Faraday::ClientError)
      end
    end
  end

  describe '#list' do
    context 'when list exists' do
      it 'returns 200' do
        list_id = 2238089

        response = subject.list(list_id)

        expect(response.status).to be 200
      end
    end
    context 'when list not exists' do
      it 'returns 404' do
        list_id = 1

        expect { subject.list(list_id) }.to raise_error(Faraday::ResourceNotFound)
      end
    end
  end

  describe '#subscriber' do
    context 'when subscriber exists' do
      it 'returns 200' do
        email = 'g6946255@trbvm.com'

        response = subject.subscriber(email)

        expect(response.status).to be 200
      end
    end
    context 'when subscriber not exists' do
      it 'returns 404' do
        email = 'not-exists-email@trbvm.com'

        expect { subject.subscriber(email) }.to raise_error(Faraday::ResourceNotFound)
      end
    end
  end

  describe '#add_subscriber' do
    let(:params) do
      {
        email: 'g6946255@trbvm.com',
        name: 'John Smith'
      }
    end
    let(:list_id) { 2238089 }

    context 'when all data is valid' do
      it 'returns 200' do
        response = subject.add_subscriber(list_id, params)

        expect(response.status).to be 200
      end
    end

    context 'when list_id is invalid' do
      it 'returns 404' do
        list_id = '1'

        expect { subject.add_subscriber(list_id, params) }.to raise_error(Faraday::ResourceNotFound)
      end
    end

    context 'when params is invalid' do
      it 'returns 400' do
        params[:email] = 'invalid email'

        expect { subject.add_subscriber(list_id, params) }.to raise_error(Faraday::ClientError)
      end
    end
  end
end