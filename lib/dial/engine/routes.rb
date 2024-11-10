# frozen_string_literal: true

Dial::Engine.routes.draw do
  scope path: "/dial", as: "dial" do
    get "profile", to: lambda { |env|
      uuid = env[Rack::QUERY_STRING].sub("uuid=", "")
      path = String ::Rails.root.join Dial::PROFILE_OUT_RELATIVE_DIRNAME, "#{uuid}.json"

      if File.exist? path
        [
          200,
          { "Content-Type" => "application/json", "Access-Control-Allow-Origin" => "https://vernier.prof" },
          [File.read(path)]
        ]
      else
        [
          404,
          { "Content-Type" => "text/plain" },
          ["Not Found"]
        ]
      end
    }
  end
end
