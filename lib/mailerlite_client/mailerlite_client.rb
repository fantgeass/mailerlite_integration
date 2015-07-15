class MailerliteClient

  attr_reader :http_client

  def initialize(api_key)
    @http_client = Faraday.new 'https://app.mailerlite.com/api/v1/', params: {apiKey: api_key} do |conn|
      conn.request :url_encoded
      conn.adapter Faraday.default_adapter
      conn.use Faraday::Response::RaiseError
    end
  end

  def campaigns
    http_client.get 'campaigns'
  end

  def subscriber(email)
    http_client.get 'subscribers/', email: email
  end

  def add_subscriber(list_id, params)
    http_client.post "subscribers/#{list_id}", params
  end

  def list(id)
    http_client.get "lists/#{id}"
  end

end