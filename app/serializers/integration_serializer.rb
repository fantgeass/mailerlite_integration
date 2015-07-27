class IntegrationSerializer < ActiveModel::Serializer
  attributes :id, :api_key, :list_id, :list_name, :service

  def service
    @object.service.to_s
  end
end
