class CreateGpas < ActiveRecord::Migration[5.0]
  def change
    create_table :gpas do |t|

      t.float :gpa
      t.integer :credit_sum
      t.integer :ap_amount
      t.integer :a_amount
      t.integer :b_amount
      t.integer :c_amount
      t.integer :d_amount
      t.integer :f_amount
      t.string :name
      t.string :password_digest
      t.timestamps
    end
  end
end
