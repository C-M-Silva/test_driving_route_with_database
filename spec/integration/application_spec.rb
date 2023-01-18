require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /create_album/new" do 
    it 'should return the form to add a new album' do 
      response = get('/create_album/new')

      expect(response.status).to eq 200
      expect(response.body).to include ('<form action="/create_album" method="POST">')
    end
  end

  context "Post /create_album" do 
    it 'allows the user to create a new album' do
      response = post('/create_album', title: 'Something', release_year: 1999, artist_id: 1)

      expect(response.status).to eq 200
      expect(response.body).to include 'Something'
      expect(response.body).to include 'Release Year: 1999'
      expect(response.body).to include 'Artist ID : 1'
    end
  end

  context 'GET /albums/:id' do 
    it 'returns a single album but its id tag' do 
      artist_id = get('/albums/2')

      expect(artist_id.status).to eq 200
      expect(artist_id.body).to include ("Surfer Rosa")
      expect(artist_id.body).to include ('Release year: 1988')
      expect(artist_id.body).to include ('Artist: Pixies')
    end
  end

  context 'GET /albums' do 
    it 'returns a list of albums as a HTML' do 
      response = get('/albums')

      expect(response.status).to eq 200 
      expect(response.body).to include ('<h2 class="album-title"> Surfer Rosa </h2>')
    end
  end

  context 'GET /artists/:id' do 
    it 'returns HTML page showing details of a single artist' do 
      response = get('/artists/1')

      expect(response.status).to eq 200 
      expect(response.body).to include '<h1> Pixies </h1>'
      expect(response.body).to include 'genre: Rock'
    end
  end

  context 'GET /artists' do
    it 'returns page with all artists and links to their pages' do 
      response = get('/artists')

      expect(response.status).to eq 200
      expect(response.body).to include ('<h2 class="album-title"> Pixies </h2>')
      expect(response.body).to include ('<h2 class="album-title"> ABBA </h2>')
      
    end
  end

  context 'GET /create_artist' do 
    it 'creates a new artist' do 
      response = get('/create_artist')

      expect(response.status).to eq 200
      expect(response.body).to include '<form action="/artist_created" method="POST">'
    end
  end

  context 'POST /artist_created' do 
    it 'creates a new artist' do 
      response = post('/artist_created', name: 'test', genre: 'rock')

      expect(response.status).to eq 200
      expect(response.body).to include 'test'
    end
  end
end
