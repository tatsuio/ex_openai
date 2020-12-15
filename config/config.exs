use Mix.Config

if Mix.env() == :test do
  config :exvcr,
    vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
    custom_cassette_library_dir: "test/fixture/custom_cassettes",
    filter_request_headers: [
      "Authorization",
      "Openai-Organization"
    ]

  if File.exists?("config/test.secret.exs") do
    import_config "test.secret.exs"
  end
end
