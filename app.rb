require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

enable :sessions

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

get '/meetups' do
  erb :index, locals: {active_meetups: Meetup.order(:name)}
end

get '/meetups/create' do
  authenticate!
  erb :create_meetup
end

post '/meetups/create' do

  meetup = Meetup.new(name: params[:meetup_name],
    location: params[:meetup_location],
    description: params[:meetup_description],
    creator_id: session[:user_id])
  if meetup.save
    id = meetup.id
    redirect "/meetups/#{id}"
  else
    flash[:notice] = meetup.errors.full_messages
    redirect '/meetups/create'
  end
end

get '/meetups/:id' do
  erb :meetup_details, locals: {meetup: Meetup.find(params[:id])}
end
