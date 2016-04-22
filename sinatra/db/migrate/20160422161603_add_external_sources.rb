class AddExternalSources < ActiveRecord::Migration
  def change
   create_table :external_sources do | t |
   t.string :category
   t.text :cat_value
   t.string :cat_impact
   t.integer :number_impact
   t.date   :created_at
   t.date   :updated_at  
  end
  end
end


