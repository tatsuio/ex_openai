defmodule ExOpenAI.CompletionTest do
  use ExUnit.Case, async: false

  alias ExOpenAI.Completion

  setup do
    bypass = Bypass.open()
    Application.put_env(:ex_openai, :base_url, "http://localhost:#{bypass.port}/")
    on_exit(fn -> Application.delete_env(:ex_openai, :base_url) end)

    {:ok, bypass: bypass, engine_id: "davinci"}
  end

  describe "Completion.create/3" do
    test "no api key returns an error", %{bypass: bypass, engine_id: engine_id} do
      Bypass.expect_once(bypass, "POST", "/v1/engines/davinci/completions", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(
          401,
          ~s({"error": {"message": "You didn't provide an API key. You need to provide your API key in an Authorization header."}})
        )
      end)

      assert {:error, response} = Completion.create(engine_id)

      assert String.match?(
               get_in(response.body, ["error", "message"]),
               ~r/^You didn't provide an API key./
             )
    end

    test "returns a successful response with a valid API key", %{
      bypass: bypass,
      engine_id: engine_id
    } do
      Bypass.expect_once(bypass, "POST", "/v1/engines/davinci/completions", fn conn ->
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer sk-test"]

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"id": "cmpl-1", "choices": [{"text": "Hello"}]}))
      end)

      assert {:ok, response} = Completion.create(engine_id, [], api_key: "sk-test")
      assert response.body["id"] == "cmpl-1"
    end
  end
end
