class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :url_voicemail
      t.string :number_from
      t.string :number_to

      t.timestamps null: false
    end
  end
end
