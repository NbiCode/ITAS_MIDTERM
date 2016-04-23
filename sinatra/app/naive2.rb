require 'rubygems'
require 'ai4r'
include Ai4r::Classifiers
include Ai4r::Data
include Ai4r::Clusterers

 

DATA_LABELS = [ 'Type', 'Size','Promotion_Discount','Month_to_Month']


DATA_ITEMS = [  
       ['Cuppaccino',     'S',    'Morning',       'Increase Revenue'],
       ['Cuppaccino',     'M',    'Morning',       'Decrease Revenue'],
       ['Cuppaccino',     'L',    'Morning',       'Increase Revenue' ],
       ['Americano',      'S',    'Morning',       'Increase Revenue' ],
       ['Americano',      'M',    'Morning',       'Increase Revenue' ],
       ['Americano',      'L',    'Morning',       'Decrease Revenue'  ],
       ['Espresso',       'S',    'Morning',       'Increase Revenue' ],
       ['Espresso',       'M',    'Morning',       'Increase Revenue' ],
       ['Espresso',       'L',    'Morning',       'Increase Revenue' ],
       ['EithopianBlend', 'S',    'Morning',       'Increase Revenue' ],
       ['EithopianBlend', 'M',    'Morning',       'Decrease Revenue'  ],
       ['EithopianBlend', 'L',    'Morning',       'Decrease Revenue'  ],
       ['CubanBlend',     'S',    'Morning',       'Increase Revenue' ],
       ['CubanBlend',     'M',    'Morning',       'Increase Revenue' ],
       ['CubanBlend',     'L',    'Evening',       'Decrease Revenue' ]
     ]

data_set = Ai4r::Data::DataSet.new(:data_items => DATA_ITEMS, :data_labels => DATA_LABELS)
#data_set = DataSet.new
#data_set.load_csv_with_labels File.dirname(__FILE__) + "/naive_bayes_data.csv"

b = NaiveBayes.new.
      set_parameters({:m=>3}).  
      build data_set
#p b.eval(["Americano", "L", "361"])

puts "Calculates Probablity of Increase or Decrease in Revenue on a promotion"

puts "Enter Coffee Type"
coffee = gets.chomp

puts "Enter Size (S/M/L)"
size = gets.chomp

puts "Time (Morning/Evening)"
time =  gets.chomp


p b.get_probability_map([coffee,size,time])






