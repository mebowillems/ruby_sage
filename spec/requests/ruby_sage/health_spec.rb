# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RubySage health", type: :request do
  before { RubySage.reset_configuration! }

  it "returns ok without any auth configuration" do
    get "/ruby_sage/health"

    expect(response).to have_http_status(:ok)
  end

  it "returns ok even when auth_check would deny access" do
    RubySage.configure { |config| config.auth_check = ->(_controller) { false } }

    get "/ruby_sage/health"

    expect(response).to have_http_status(:ok)
  end

  it "includes the version in the response" do
    get "/ruby_sage/health"

    expect(response.parsed_body).to include("status" => "ok", "version" => RubySage::VERSION)
  end
end
