# yt_construct_client constructs a client

    Code
      yt_construct_client("a", "b")
    Message <cliMessage>
      <httr2_oauth_client>
      name: youtube_data_api
      id: a
      secret: <REDACTED>
      token_url: https://oauth2.googleapis.com/token
      auth: oauth_client_req_auth_header

---

    Code
      yt_construct_client()
    Message <cliMessage>
      <httr2_oauth_client>
      name: youtube_data_api
      id: an_id
      secret: <REDACTED>
      token_url: https://oauth2.googleapis.com/token
      auth: oauth_client_req_auth_header

