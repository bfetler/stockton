class AddStockSymbolUniqueness < ActiveRecord::Migration
  def up
    add_index :stocks, :companysymbol, :unique => true
  end

  def down
#   remove_index :stocks, :companysymbol
  end
end
