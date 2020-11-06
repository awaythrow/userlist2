def app
  App
end

describe App do
  it "responds with a welcome message" do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Welcome to the Sinatra Template!")
  end

  describe "CRUD users" do
    it "returns valid json" do
      get "/users"
      expect(last_response).to be_ok
      expect(last_response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse last_response.body).to_not be_nil
    end

    context "create several users" do
      before do
        @users = [
          { firstname: 'user', lastname: 'one', email: 'userone@example.com' },
          { firstname: 'user', lastname: 'two', email: 'usertwo@example.com' },
          { firstname: 'user', lastname: 'three', email: 'userthree@example.com' },
        ]
        @users.map! { |user| user.transform_keys(&:to_s) }
        @users.each do |user|
          post "/users", user
        end
      end
      it "returns all the users" do
        get "/users"
        expect(last_response).to be_ok

        response_data = JSON.parse(last_response.body)
        response_data.each { |h| h.delete("id") }
        expect(response_data).to include(*@users)
      end
    end

    context "delete users" do
      before do
        @users = [
          { firstname: 'user', lastname: 'one', email: 'userone@example.com' },
          { firstname: 'user', lastname: 'two', email: 'usertwo@example.com' },
          { firstname: 'user', lastname: 'three', email: 'userthree@example.com' },
        ]
        @users.map! { |user| user.transform_keys(&:to_s) }
        @users.each do |user|
          post "/users", user
        end
      end
      it "deletes users" do
        get "/users"
        expect(last_response).to be_ok

        response_data = JSON.parse(last_response.body)
        response_data.each do |user|
          delete "users/#{user['id']}"
          expect(last_response.status).to eq 202
        end
      end
    end
  end
end
