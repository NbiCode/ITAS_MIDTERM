require_relative './models/constants.rb'

helpers do 
  
  def cost_of_goods_sold
    @company.CompanyProfile.annual_sales * @company.CompanyProfile.ave_cost_per_unit
  end 

  def gross_profit 
    @company.CompanyProfile.annual_sales - (cost_of_goods_sold + @company.CompanyProfile.staff_costs)
  end 

  def net_profit
    gross_profit - @company.CompanyProfile.overheads - @company.CompanyProfile.taxes - @company.CompanyProfile.interest
  end

  def sale_per_hour
    @company.CompanyProfile.annual_sales / (@company.CompanyProfile.avg_open_business_hours * Constants::ANNUAL_BUSINESS_DAYS)
  end

  def transactions_per_hour 
    @company.CompanyProfile.volume_of_trx / (@company.CompanyProfile.avg_open_business_hours * Constants::ANNUAL_BUSINESS_DAYS)
  end 

  def avg_product_margin
    @company.CompanyProfile.avg_unit_price - @company.CompanyProfile.avg_unit_cost
  end

  def debt_ratio
    @company.CompanyProfile.current_liabilities/net_profit
  end 
end   

# Homepage (Root path)
get '/' do
  erb :index
end


