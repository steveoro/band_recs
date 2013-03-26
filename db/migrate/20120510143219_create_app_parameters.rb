class CreateAppParameters < ActiveRecord::Migration
  def change
    create_table :app_parameters do |t|
      t.timestamps
      t.integer :code
      t.string :controller_name
      t.string :action_name
      t.string :a_string
      t.boolean :a_bool
      t.integer :a_integer
      t.datetime :a_date
      t.decimal :a_decimal
      t.decimal :a_decimal_2
      t.decimal :a_decimal_3
      t.decimal :a_decimal_4
      t.integer :range_x
      t.integer :range_y
      t.string :a_name
      t.string :a_filename
      t.integer :code_type_1
      t.integer :code_type_2
      t.integer :code_type_3
      t.integer :code_type_4
      t.text :free_text_1
      t.text :free_text_2
      t.text :free_text_3
      t.text :free_text_4
      t.boolean :free_bool_1
      t.boolean :free_bool_2
      t.boolean :free_bool_3
      t.boolean :free_bool_4
      t.text :description
    end

    add_index :app_parameters, ["code"], :name => "code", :unique => true
  end
end
