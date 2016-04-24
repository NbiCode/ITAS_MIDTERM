# Homepage (Root path)
require 'pry'
require 'nokogiri'
# require 'restclient'
require 'open-uri/cached'
require 'ai4r'
include Ai4r::Classifiers
include Ai4r::Data
include Ai4r::Clusterers

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

helpers do

DATA_LABELS_ID3 = [ 'Coffee', 'Discount', 'Time', 'Revenue_Goes'  ]

DATA_ITEMS_ID3 = [  
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


  def calc_id3  
    data_set = Ai4r::Data::DataSet.new(:data_items => DATA_ITEMS_ID3, :data_labels => DATA_LABELS_ID3)
    id3 = Ai4r::Classifiers::ID3.new.build(data_set)
    id3.get_rules
  end   


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


  def calc_prob(coffee,size,time)
    data_set = Ai4r::Data::DataSet.new(:data_items => DATA_ITEMS, :data_labels => DATA_LABELS)
    b = NaiveBayes.new.set_parameters({:m=>3}).build data_set
    b.get_probability_map([coffee,size,time])
  end

  def get_sentences
    @sentences = []
    doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/Small_business"))
    regex = /[^.]*small business[^.]*\./i
    a = doc.traverse { |x| 
      if x.text =~ regex
        @sentences << x
      end
    }
  end
 
end

get '/' do
  if session[:company_id]
    @company = Company.find(session[:company_id])
  end
  erb :index
end

post '/login' do
  if @company = Company.find_by_username(params[:username])
    session[:company_id] = @company.id
    session[:id] = params[:id]
    redirect '/dashboard'
  else
    redirect '/register'
  end
end

get '/register' do
  erb :register
end

post '/register' do
  @user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    )
  if @user.save 
    session[:company_id] = @user.id
    redirect '/dashboard'
  else
    erb :register
  end
end

get '/dashboard' do
  get_sentences 
  if session[:company_id]
    @company = CompanyProfile.find_by(session[:company_id])
  else
    redirect '/register'
  end
  erb :'dashboard'
end

get '/prob' do
    erb :'/prob'
end

post '/prob' do
  @result = calc_prob(params[:coffee],params[:size],params[:time])
  erb :'/prob'
end

get '/result' do
  erb :'/result'
end

get '/machine' do
   @id3 = calc_id3
  erb :'/machine'
end

get '/tracker' do
  get_sentences
  erb :tracker
end

get '/logout' do
  erb :index
end

