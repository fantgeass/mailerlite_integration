class IntegrationsController < ApplicationController
  before_action :find_integration, only: [:show, :update, :destroy]

  def index
    integrations = Integration.all
    render json: integrations
  end

  def show
    render json: @integration
  end

  def create
    integration = Integration.new(integration_params)

    if integration.save
      render json: integration, status: :created, location: integration
    else
      render_errors(integration)
    end
  end

  def update
    if @integration.update(integration_params)
      render json: @integration
    else
      render_errors(@integration)
    end
  end

  def destroy
    @integration.destroy!
    head :no_content
  end

  def lists
    lists = MailerliteIntegration.lists(params[:api_key])

    if lists
      render json: lists
    else
      render json: {error: 'Wrong API Key'}, status: :unprocessable_entity
    end
  end

  private

  def integration_params
    params.permit(:service, :api_key, :list_id, :list_name)
  end

  def find_integration
    @integration = Integration.find(params[:id])
  end
end