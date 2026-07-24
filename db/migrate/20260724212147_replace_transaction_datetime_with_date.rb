class ReplaceTransactionDatetimeWithDate < ActiveRecord::Migration[8.1]
  def up
    add_column :transactions, :date, :date

    Transaction.all.each do |txn|
      txn.update!(date: txn.datetime.to_date)
    end

    remove_column :transactions, :datetime, :datetime
  end

  def down
    add_column :transactions, :datetime, :datetime

    Transaction.all.each do |txn|
      txn.update!(datetime: txn.date.to_datetime)
    end

    remove_column :transactions, :date, :date
  end
end
