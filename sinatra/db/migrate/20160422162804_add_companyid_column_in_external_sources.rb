class AddCompanyidColumnInExternalSources < ActiveRecord::Migration
  
  def change
    
    add_column :external_sources, :company_id, :integer

  end
end


