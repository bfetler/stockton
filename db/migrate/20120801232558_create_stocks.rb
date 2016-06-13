class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :companyname
      t.string :companysymbol
      t.string :value
      t.string :delta

      t.timestamps
    end
  end
end
