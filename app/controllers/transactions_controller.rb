class TransactionsController < ApplicationController
  include TransactionList

  allow_unauthenticated_access only: [ :show, :list ]
  before_action :set_transaction, except: [ :index, :list, :export ]

  def index
    skip_authorization
  end

  def list
    skip_authorization

    @show_filters = ActiveModel::Type::Boolean.new.cast(params[:show_filters])
    @disable_filters = ActiveModel::Type::Boolean.new.cast(params[:disable_filters])
    @reimburse_transaction_id = params[:reimburse_transaction_id]

    apply_transaction_filters(current_user)
  end

  def export
    skip_authorization

    apply_transaction_filters(current_user)

    respond_to do |format|
      format.csv do
        render csv: @transactions
      end

      format.pdf do
        html = render_to_string(template: "transactions/export", layout: "pdf")
        pdf = Grover.new(html).to_pdf

        send_data pdf, filename: "transaction_export_#{Date.today.to_s.gsub("-", "_")}", type: "application/pdf"
      end
    end
  end

  def show
    authorize_with_share @transaction, params[:share_sid]
  end

  def edit_memo
    authorize @transaction
  end

  def edit_category
    authorize @transaction
  end

  def add_tag_modal
    authorize @transaction
  end

  def toggle_tag
    authorize @transaction

    tag = Tag.find(params[:tag_id])

    authorize tag

    if @transaction.tags.include? tag
      TagTransaction.find_by(tag:, associated_transaction: @transaction).destroy
    else
      @transaction.tags << tag
    end

    redirect_back_or_to @transaction
  end

  def update
    authorize @transaction

    @transaction.update!(transaction_params)

    redirect_back_or_to @transaction
  end

  def reimburse_modal
    authorize @transaction
  end

  def mark_reimbursed
    reimbursing_transaction = current_user.transactions.find(params[:reimbursing_transaction_id])

    authorize @transaction
    authorize reimbursing_transaction

    reimbursing_transaction.update!(reimbursement_for: @transaction)

    redirect_back_or_to @transaction
  end

  def remove_reimbursement_for
    authorize @transaction

    @transaction.update!(reimbursement_for: nil)

    redirect_back_or_to @transaction
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:memo, :category_id)
  end
end
