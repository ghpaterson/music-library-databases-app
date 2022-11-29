require "spec_helper"
require "rack/test"
require_relative '../../app'

# def reset_albums_table
#   seed_sql = File.read('spec/seeds/album_seeds.sql')
#   connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
#   connection.exec(seed_sql)
# end

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
      expected_response = "Baltimore, Bossanova, Doolittle, Fodder on My Wings, Folklore, Here Comes the Sun, I Put a Spell on You, Lover, Ring Ring, Super Trouper, Surfer Rosa, Waterloo"
      expect(response_2.status).to eq 200
      expect(response_2.body).to eq(expected_response)
    end
  end

  context "POST /albums" do
    it 'creates a new album and lists all the albums' do
      
      response = post("/albums", title: "Voyage", release_year: "2022", artist_id: 2)
      expect(response.status).to eq(200)
      response_2 = get("/albums")
      expected_response = "Baltimore, Bossanova, Doolittle, Fodder on My Wings, Folklore, Here Comes the Sun, I Put a Spell on You, Lover, Ring Ring, Super Trouper, Surfer Rosa, Voyage, Waterloo"
      expect(response_2.status).to eq 200
      expect(response_2.body).to eq(expected_response)
    end
  end

  context "GET /artists" do
    it "returns a list of all the artists" do
      response_2 = get("/artists")
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"
      expect(response_2.status).to eq 200
      expect(response_2.body).to eq(expected_response)
    end
  end

  context "POST /artists" do
    it "creates a new artist and lists all the artists" do
      response = post("/artists", name: "Wild nothing", genre: "Indie")
      expect(response.status).to eq 200
      response_2 = get("/artists")
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing"
      expect(response_2.status).to eq 200
      expect(response_2.body).to eq(expected_response)
    end

  end
end

