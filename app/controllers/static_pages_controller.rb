class StaticPagesController < ApplicationController
  def index
  end

  def code_verifier
    "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
  end

  def code_challenge
    padded_result = Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier))
    padded_result.split("=")[0]
  end

  def state
    params[:state] || "123456789"
  end

  def snaplogin
    base = "https://accounts.snapchat.com/accounts/oauth2/auth"
    client_id = Rails.application.credentials.fetch(:snapchat_dev_client_id)
    redirect_uri = "http://localhost:3000/snapcode"
    code_challenge_method = "S256"
    scopes = [
      "https://auth.snapchat.com/oauth2/api/user.bitmoji.avatar",
      "https://auth.snapchat.com/oauth2/api/user.display_name",
    ]
    query = "client_id=#{client_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=#{scopes.join(" ")}&state=#{state}&code_challenge=#{code_challenge}&code_challenge_method=#{code_challenge_method}"
    url = "#{base}?#{query}"
    redirect_to url
  end

  def snapcode
    begin
      client_id = Rails.application.credentials.fetch(:snapchat_dev_client_id)
      creds = [
        client_id,
        Rails.application.credentials.fetch(:snapchat_dev_secret)
      ].join(":")
      resp = RestClient.post(
        "https://accounts.snapchat.com/accounts/oauth2/token", {
          grant_type: "authorization_code",
          redirect_uri: "http://localhost:3000/snapcode",
          client_id: client_id,
          code: params[:code],
          code_verifier: code_verifier
        },
        headers={Authorization: "Basic #{Base64.strict_encode64(creds)}"})
    rescue => e
      render json: e.response.body
      return
    end

    render json: resp
  end
end
