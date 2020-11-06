require './config/environment'

class App < Sinatra::Base

  get "/" do
    erb :index
  end

  get '/users' do
    users = Users.all
    json users
  end

  get '/users/:id' do
    user = Users.find(params[:id])
    json user
  end

  post '/users' do
    user = Users.create(params)
    status 201
    json user
  end

  put '/users/:id' do
    user = Users.find(params[:id])
    user.update(params)
    status 204
    json user
  end

  delete '/users/:id' do
    user = Users.destroy(params[:id])
    status 202
    json user
  end

end
