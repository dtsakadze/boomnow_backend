class SearchService
  BASE_URL = "https://app.boomnow.com/open_api/v1"
  AUTH_PATH = "/auth/token"
  LISTINGS_PATH = "/listings"

  def initialize(params)
    @params = params
    @client_id = ENV["CLIENT_ID"]
    @client_secret = ENV["CLIENT_SECRET"]
  end

  def run
    token = get_auth_token
    get_listings(token)
  end

  private

  def get_auth_token
    request_wrapper do
      res = HTTPX.post(BASE_URL + AUTH_PATH, form: { client_id: @client_id, client_secret: @client_secret })
      body = JSON.parse(res.body)
      body["access_token"]
    end
  end

  def get_listings(token)
    city_param = "city=#{@params[:city]}"
    adults_param = "adults=#{@params[:adults]}"
    url = "#{BASE_URL + LISTINGS_PATH}?#{adults_param}&#{city_param}"

    request_wrapper do
      res = HTTPX.get(url, headers: {
        "Authorization": "Bearer #{token}",
        "Content-type": "application/json"
      })
      JSON.parse(res.body)
    end
  end

  def request_wrapper
    begin
      yield
    rescue
      { error: "HTTP request failed" }
    end
  end
end
