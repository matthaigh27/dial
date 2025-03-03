# frozen_string_literal: true

Dial::Engine.routes.draw do
  scope path: "/dial", as: "dial" do
    get "profile", to: lambda { |env|
      uuid = env[::Rack::QUERY_STRING].sub "uuid=", ""
      path = String ::Rails.root.join Dial::VERNIER_PROFILE_OUT_RELATIVE_DIRNAME, "#{uuid}.json.gz"

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

    get "assets/dial.css", to: proc {
      [200, {"Content-Type" => "text/css"}, [File.read(File.join(Dial::Engine.root, "lib/dial/assets/dial.css"))]]
    }

    get "assets/dial.js", to: proc {
      [200, {"Content-Type" => "application/javascript"}, [File.read(File.join(Dial::Engine.root, "lib/dial/assets/dial.js"))]]
    }
  end
end
