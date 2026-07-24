class TransactionsController < ApplicationController
  before_action :set_transaction

  def show
    authorize @transaction
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
