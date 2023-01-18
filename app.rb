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

  get '/create_album/new' do 
    return erb(:create_album)
  end

  post '/create_album' do 
    repo = AlbumRepository.new 
    new_album = Album.new 
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    @result = repo.create(new_album)
    
    return erb(:album_created)
  end


  get '/albums/:id' do 
    repo = AlbumRepository.new 
    artist_repo = ArtistRepository.new
    @album = repo.find(params[:id])

    @artist = artist_repo.find(@album.artist_id)

    return erb(:index)
  end

  get '/albums' do 
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  get '/artists/:id' do 
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  get '/artists' do 
    repo = ArtistRepository.new
    @all_artists = repo.all

    return erb(:artists)
  end

  get '/create_artist' do 
    return erb(:create_artist)
  end

  post '/artist_created' do 
    repo = ArtistRepository.new 
    new_artist = Artist.new 
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    @result = repo.create(new_artist)

    return erb(:artist_created)
  end

end