class MailerliteIntegration < EmailIntegration

  class << self
    def add(name, email, list_id, api_key)
      subscriber_exists = subscriber_exists?(email, api_key)

      exceptions_handler do
        response = client(api_key).add_subscriber(list_id, {name: name, email: email})
        if response.status == 200
          !subscriber_exists
        else
          raise EmailIntegration::CustomError.new("Unexpected response status: #{response.status}")
        end
      end

    end

    def valid_api_key?(api_key)
      exceptions_handler do
        response = client(api_key).campaigns
        response.status == 200
      end

    rescue EmailIntegration::CredentialsError
      return false
    end

    def valid_list?(list_id, api_key)
      exceptions_handler do
        response = client(api_key).list(list_id)
        response.status == 200
      end

    rescue EmailIntegration::ListNotFoundError
      return false
    end

    def lists(api_key)
      exceptions_handler do
        response = client(api_key).lists
        ActiveSupport::JSON.decode(response.body)["Results"]
      end

    rescue EmailIntegration::CredentialsError
      return false
    end

    private

    def subscriber_exists?(email, api_key)
      exceptions_handler do
        response = client(api_key).subscriber(email)
        response.status == 200
      end

    rescue EmailIntegration::ListNotFoundError
      return false
    end

    def exceptions_handler
      yield
    rescue Faraday::ResourceNotFound
      raise EmailIntegration::ListNotFoundError
    rescue Faraday::Error::ClientError => e
      case e.response[:status]
        when 400
          raise EmailIntegration::RejectedError.new(e.message)
        when 401
          raise EmailIntegration::CredentialsError.new(e.message)
        else
          raise EmailIntegration::ConnectionError.new(e.message)
      end
    end

    def client(api_key)
      MailerliteClient.new(api_key)
    end
  end

end