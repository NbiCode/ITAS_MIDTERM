class Company < ActiveRecord::Base
  
belongs_to :industry
has_one :company_profile
has_one :location
has_one :user
has_many :results


end 