# frozen_string_literal: true

module RubySage
  # Reports whether the mounted engine is reachable. Intentionally bypasses
  # auth so host apps and load balancers can verify the mount without credentials.
  class HealthController < ApplicationController
    skip_before_action :authorize_ruby_sage!

    # Renders the engine health payload.
    #
    # @return [void]
    def show
      render json: { status: "ok", version: RubySage::VERSION }
    end
  end
end
