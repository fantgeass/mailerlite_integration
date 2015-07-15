require 'rails_helper'

RSpec.describe MailerliteIntegration do
  let(:api_key) { 'valid_key' }

  describe '.add' do
    let(:name) { 'John Smith' }
    let(:email) { 'john@mail.com' }
    let(:list_id) { 'valid_list_id' }

    context 'when subscriber not exists' do
      it 'returns true' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 404)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 200)

        result = described_class.add(name, email, list_id, api_key)

        expect(result).to be true
      end
    end

    context 'when subscriber exists' do
      it 'returns false' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 200)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 200)

        result = described_class.add(name, email, list_id, api_key)

        expect(result).to be false
      end
    end

    context 'when list_id is invalid' do
      it 'fails with ListNotFoundError' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 200)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 404)

        expect { described_class.add(name, email, list_id, api_key) }.to raise_error(EmailIntegration::ListNotFoundError)
      end
    end

    context 'when email is invalid' do
      it 'fails with RejectedError' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 200)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 400)

        expect { described_class.add(name, email, list_id, api_key) }.to raise_error(EmailIntegration::RejectedError)
      end
    end

    context 'when api_key is invalid' do
      it 'fails with CredentialsError' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 200)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 401)

        expect { described_class.add(name, email, list_id, api_key) }.to raise_error(EmailIntegration::CredentialsError)
      end
    end

    context 'when connection/other issues' do
      it 'fails with ConnectionError' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 200)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 500)

        expect { described_class.add(name, email, list_id, api_key) }.to raise_error(EmailIntegration::ConnectionError)
      end
    end

    context 'when unexpected response' do
      it 'fails with CustomError' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/subscribers/?apiKey=#{api_key}&email=#{email}").
            to_return(:status => 200)
        stub_request(:post, "https://app.mailerlite.com/api/v1/subscribers/#{list_id}?apiKey=#{api_key}").
            with(:body => {"email"=> email, "name"=> name}).to_return(:status => 302)

        expect { described_class.add(name, email, list_id, api_key) }.to raise_error(EmailIntegration::CustomError)
      end
    end
  end

  describe '.valid_api_key?' do
    context 'when key is valid' do
      it 'returns true' do
        stub_request(:get, "https://app.mailerlite.com/api/v1/campaigns?apiKey=#{api_key}").to_return(:status => 200)

        result = described_class.valid_api_key?(api_key)

        expect(result).to be true
      end
    end
    context 'when key is invalid' do
      it 'returns false' do
        api_key = 'invalid_key'
        stub_request(:get, "https://app.mailerlite.com/api/v1/campaigns?apiKey=#{api_key}").to_return(:status => 401)

        result = described_class.valid_api_key?(api_key)

        expect(result).to be false
      end
    end
  end

  describe '.valid_list??' do
    context 'when list is valid' do
      it 'returns true' do
        list_id = 'valid_list_id'
        stub_request(:get, "https://app.mailerlite.com/api/v1/lists/#{list_id}?apiKey=#{api_key}")
            .to_return(:status => 200)

        result = described_class.valid_list?(list_id, api_key)

        expect(result).to be true
      end
    end
    context 'when list is invalid' do
      it 'returns false' do
        list_id = 'invalid_list_id'
        stub_request(:get, "https://app.mailerlite.com/api/v1/lists/#{list_id}?apiKey=#{api_key}")
            .to_return(:status => 404)

        result = described_class.valid_list?(list_id, api_key)

        expect(result).to be false
      end
    end
  end
end