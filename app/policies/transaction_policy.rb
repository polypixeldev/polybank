class TransactionPolicy < ApplicationPolicy
  def show?
    record.account.user == user
  end

  def update?
    record.account.user == user
  end

  alias_method :edit_category?, :update?
  alias_method :edit_memo?, :update?
  alias_method :add_tag_modal?, :update?
  alias_method :toggle_tag?, :update?
  alias_method :comment?, :update?
  alias_method :reimburse_modal?, :update?
  alias_method :mark_reimbursed?, :update?
  alias_method :remove_reimbursement_for?, :update?
end
