require 'rubygems'
require 'ai4r'
include Ai4r::Classifiers
include Ai4r::Data
include Ai4r::Clusterers


DATA_LABELS = [ 'Coffee', 'Discount', 'Time', 'Revenue_Goes'  ]

DATA_ITEMS = [  
       ['AMERICANO',  '<30',      'MORNING', 'UP'],
       ['CUPPACCINO',     '<30',      'MORNING', 'UP'],
       ['CUPPACCINO',     '<30',      'EVENING', 'UP'],
       ['AMERICANO',  '<30',      'MORNING', 'UP'],
       ['AMERICANO',  '<30',      'MORNING', 'UP'],
       ['CUPPACCINO',     '[30-50)',  'MORNING', 'UP'],
       ['AMERICANO',  '[30-50)',  'EVENING', 'UP'],
       ['CUPPACCINO',     '[30-50)',  'EVENING', 'UP'],
       ['AMERICANO',  '[30-50)',  'EVENING', 'DOWN'],
       ['CUPPACCINO',     '[50-80]', 'MORNING', 'DOWN'],
       ['AMERICANO',  '[50-80]', 'EVENING', 'DOWN'],
       ['AMERICANO',  '[50-80]', 'MORNING', 'DOWN'],
       ['CUPPACCINO',     '[50-80]', 'EVENING', 'DOWN'],
       ['AMERICANO',  '[50-80]', 'EVENING', 'DOWN'],
       ['CUPPACCINO',     '>80',      'EVENING', 'DOWN']
     ]

data_set = Ai4r::Data::DataSet.new(:data_items => DATA_ITEMS, :data_labels => DATA_LABELS)
id3 = Ai4r::Classifiers::ID3.new.build(data_set)

puts id3.get_rules
  # =>  if age_range=='<30' then marketing_target='Y'
        # elsif age_range=='[30-50)' and city=='CUPPACCINO' then marketing_target='Y'
        # elsif age_range=='[30-50)' and city=='AMERICANO' then marketing_target='N'
        # elsif age_range=='[50-80]' then marketing_target='N'
        # elsif age_range=='>80' then marketing_target='Y'
        # else raise 'There was not enough information during training to do a proper induction for this data element' end

#id3.eval(['AMERICANO', '<30', 'M'])
  # =>  'Y'