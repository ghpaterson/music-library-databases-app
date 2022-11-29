# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    albums = repo.all

    response_2 = albums.map do |album|
      album.title
    end.sort.join(", ")

    return response_2
  end


  post '/albums' do
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return nil
  end

  get '/artists' do
    repo = ArtistRepository.new
    artists = repo.all

    response_2 = artists.map do |artist|
      artist.name
    end.join(", ")
    return response_2
  end

  post '/artists' do
    
  end
end