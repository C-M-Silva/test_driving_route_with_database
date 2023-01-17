require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums_check' do
    it 'should return the list of albums' do 
      response = get('/albums_check')

      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq 200
      expect(response.body).to eq (expected_response)

    end
  end

  context "Post /create_albums" do 
    it 'allows the user to create a new album' do
      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring, Voyage'

      response = post('/create_album', title: "Voyage", release_year: 2022, artist_id: 1)
      
      expect(response.status).to eq 200

      response = get('/albums_check')

      expect(response.body).to eq (expected_response)
      
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
end
