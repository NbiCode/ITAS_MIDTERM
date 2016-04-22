# Homepage (Root path)
require 'pry'
require 'nokogiri'
# require 'restclient'
require 'open-uri/cached'

helpers do

  def get_sentences
    @sentences = []
    doc = Nokogiri::HTML(open("https://www.franchisehelp.com/industry-reports/pizza-industry-report/"))
    regex = /[^.]*Sizzlin[^.]*\./i
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
  # @company_profiles = CompanyProfile.find_by(session[id: params[:id]])
  erb :'dashboard/index'
end



=begin

THIS CODE WORKS

post '/login' do
  session[:username] = params[:username]
  redirect '/dashboard/:username'
end

get '/dashboard/:username' do
  @user = User.all
  erb :dashboard 
end

===================

THIS CODE WORKS
get '/' do
  erb :index
end

post '/login' do
  session[:username] = params[:username]
  redirect '/dashboard/:username'
end

get '/dashboard/:username' do
  @company_profiles = CompanyProfile.all
  erb :dashboard 
end

=================

THIS CODE WORKS

get '/' do
  erb :index
end

post '/login' do
  redirect '/dashboard'
end

get '/dashboard' do
  @company_profiles = CompanyProfile.all
  erb :dashboard
end


=====================

THIS CODE WORKS AS WELL

get '/' do
  erb :index
end

post '/login' do
  session[:username] = params[:username]
  session[:password] = params[:password]
  session[:email] = params[:email]
  redirect '/dashboard/:username'
end

get '/dashboard/:username' do
  erb :dashboard
end

=====================

THIS CODE WORKS TOO
get '/' do
  erb :index
end

post '/login' do
  redirect '/dashboard'
end

get '/dashboard' do
  @companies = Company.all
  erb :dashboard
end

======================
THIS CODE ALSO WORKS

get '/' do
  erb :index
end

post '/login' do
  redirect '/dashboard'
end

get '/dashboard' do
  @company_profiles = CompanyProfile.all
  erb :dashboard
end

=end

