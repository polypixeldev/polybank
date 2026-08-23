class HcbOrganizationsController < ApplicationController
  before_action :set_hcb_organization

  def sync
    authorize @hcb_organization

    @hcb_organization.sync_hcb_transactions

    redirect_back_or_to account_path(@hcb_organization.account)
  end

  private

  def set_hcb_organization
    @hcb_organization = HcbOrganization.find(params[:id])
  end
end
