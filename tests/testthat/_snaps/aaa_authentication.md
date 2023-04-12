# construct_client constructs a client

    Code
      construct_client("a", "b")
    Message <cliMessage>
      <httr2_oauth_client>
      name: video_info_api
      id: a
      secret: <REDACTED>
      token_url: https://oauth2.googleapis.com/token
      auth: oauth_client_req_auth_header

---

    Code
      construct_client()
    Message <cliMessage>
      <httr2_oauth_client>
      name: video_info_api
      id: an_id
      secret: <REDACTED>
      token_url: https://oauth2.googleapis.com/token
      auth: oauth_client_req_auth_header

