class AddExternalDatas < ActiveRecord::Migration
 def change
  create_table :external_datas do | t |
   t.string :category
   t.string :cat_news
   t.integer :cat_figure
   t.date   :created_at
   t.date   :updated_at  
  end
  end
end
 