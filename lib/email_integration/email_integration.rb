class EmailIntegration
  class EmailIntegrationError < StandardError; end

  class PersistentError < EmailIntegrationError; end
  class ListNotFoundError < PersistentError; end
  class CredentialsError < PersistentError; end
  class RejectedError < PersistentError; end
  class CustomError < PersistentError; end

  class TemporaryError < EmailIntegrationError; end
  class ConnectionError < TemporaryError; end
end