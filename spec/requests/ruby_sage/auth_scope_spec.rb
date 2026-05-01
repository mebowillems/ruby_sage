# frozen_string_literal: true

require "rails_helper"

# Auth scope behaviour is verified against admin/scans (a representative protected
# endpoint). The health endpoint is intentionally public and tested separately.
RSpec.describe "RubySage auth scopes", type: :request do
  before do
    RubySage.reset_configuration!
    RubySage::Scan.delete_all
  end

  after do
    RubySage.reset_configuration!
    next unless RubySage::Admin::ScansController.method_defined?(:current_user, false)

    RubySage::Admin::ScansController.remove_method(:current_user)
  end

  it "allows public rate limited access" do
    RubySage.configure { |config| config.scope = :public_rate_limited }

    get "/ruby_sage/admin/scans"

    expect(response).to have_http_status(:ok)
  end

  it "blocks signed in access when current_user is unavailable" do
    RubySage.configure { |config| config.scope = :signed_in }

    get "/ruby_sage/admin/scans"

    expect(response).to have_http_status(:forbidden)
  end

  it "allows signed in access when current_user is present" do
    RubySage.configure { |config| config.scope = :signed_in }
    RubySage::Admin::ScansController.define_method(:current_user) { Object.new }

    get "/ruby_sage/admin/scans"

    expect(response).to have_http_status(:ok)
  end

  it "blocks admin access without an explicit auth check" do
    RubySage.configure { |config| config.scope = :admin }

    get "/ruby_sage/admin/scans"

    expect(response).to have_http_status(:forbidden)
  end
end
