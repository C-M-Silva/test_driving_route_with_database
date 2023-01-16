require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'should return the list of albums' do 
      response = get('/albums')

      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq 200
      expect(response.body).to eq (expected_response)

    end
  end

  context "Post /create_albums" do 
    it 'allows the user to create a new album' do
      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring, Voyage'

      response = post('/create_album', title: "Voyage", release_year: 2022, artist_id: 2)
      
      expect(response.status).to eq 200

      response = get('/albums')

      expect(response.body).to eq (expected_response)
      
    end
  end

  context "GET /artists" do 
    it 'returns a list of artists in the database' do 
      artists_name = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'
      response = get('/artists')

      expect(response.status).to eq 200
      expect(response.body).to eq artists_name
    end
  end

  context "POST /artists" do 
    it 'adds a new artist' do 
      artists_name = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Wild nothing'
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      
      expect(response.status).to eq 200 

      updated_artists = get('/artists')

      expect(updated_artists.body). to eq artists_name
    end
  end
end
