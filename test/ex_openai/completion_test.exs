defmodule ExOpenAI.CompletionTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExOpenAI.Completion

  setup_all do
    HTTPoison.start()
  end

  describe "Completion.create/3" do
    setup do
      {:ok, engine_id: "davinci", valid_api_key: Application.get_env(:ex_openai, :valid_api_key)}
    end

    test "no api key returns an error", %{engine_id: engine_id} do
      use_cassette "completions/create/errors/no_api_key" do
        assert {:error, response} = Completion.create(engine_id)

        assert String.match?(
                 get_in(response.body, ["error", "message"]),
                 ~r/^You didn't provide an API key./
               )
      end
    end

    test "returns a successful response with a valid API key", %{
      valid_api_key: api_key,
      engine_id: engine_id
    } do
      use_cassette "completions/create/successful/no_parameters" do
        assert {:ok, _response} = Completion.create(engine_id, [], api_key: api_key)
      end
    end
  end
end
