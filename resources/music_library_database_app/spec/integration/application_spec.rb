require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
 

  before(:each) do
    reset_albums_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  context "GET /albums" do
    it "returns list of album titles" do
      response_2 = get("/albums")
      expect(response_2.status).to eq 200
      expect(response_2.body).to include('<h1>Albums</h1>')
      expect(response_2.body).to include('<a href="/albums/1">Doolittle</a>')
      expect(response_2.body).to include('<a href="/albums/2">Surfer Rosa</a>')
      expect(response_2.body).to include('<a href="/albums/3">Waterloo</a>')
    end
  end

  context "POST /albums" do
    it 'creates a new album and lists all the albums' do
      
      response = post("/albums", title: "Voyage", release_year: "2022", artist_id: 2)
      expect(response.status).to eq(200)
      response_2 = get("/albums")
      
      expect(response_2.status).to eq 200
      expect(response_2.body).to include('<h1>Albums</h1>')
      expect(response_2.body).to include('Voyage')
      #expect(response_2.body).to include('Released: 2022')
    end
  end

  context "GET /artists" do
    it "returns a list of all the artists" do
      response_2 = get("/artists")
      expect(response_2.status).to eq 200
      expect(response_2.body).to include('<h1>Artists</h1>')
      expect(response_2.body).to include('<a href="/artists/1">Pixies</a>')
      expect(response_2.body).to include('<a href="/artists/2">ABBA</a>')
      expect(response_2.body).to include('<a href="/artists/3">Taylor Swift</a>')

    end
  end

  context "POST /artists" do
    it "creates a new artist and lists all the artists" do
      response = post("/artists", name: "Wild nothing", genre: "Indie")
      expect(response.status).to eq 200
      response_2 = get("/artists")
      expect(response_2.status).to eq 200
      expect(response_2.body).to include ('<h1>Artists</h1>')
      expect(response_2.body).to include('Wild nothing')
    end
  end

  context "GET/albums/:id" do
    it "returns information about album 1" do
      response = get('/albums/1')

      expect(response.status).to eq 200
      expect(response.body).to include ('<h1>Doolittle</h1>')
      expect(response.body).to include ('Release year: 1989')
      expect(response.body).to include ('Artist: Pixies')
    end

    it "returns information about album 2" do
      response = get('/albums/2')

      expect(response.status).to eq 200
      expect(response.body).to include ('<h1>Surfer Rosa</h1>')
      expect(response.body).to include ('Release year: 1988')
      expect(response.body).to include ('Artist: Pixies')
    end
  end

  context "GET/artists/:id" do
    it "returns info about artist 1" do
      response = get('/artists/1')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include ('Genre: Rock')
    end
  end


  
end

