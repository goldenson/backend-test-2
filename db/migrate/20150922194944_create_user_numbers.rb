class CreateUserNumbers < ActiveRecord::Migration
  def change
    create_table :user_numbers do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :sip_endpoint

      t.timestamps null: false
    end
  end
end
