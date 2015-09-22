class CreateCompanyNumbers < ActiveRecord::Migration
  def change
    create_table :company_numbers do |t|
      t.string :sip_endpoint

      t.timestamps null: false
    end
  end
end
