defmodule ExOpenAI.CompletionTest do
  use ExUnit.Case, async: true

  alias ExOpenAI.Completion

  describe "Completion.create/3" do
    setup do
      {:ok, engine_id: "davinci"}
    end

    test "no api key returns an error", %{engine_id: engine_id} do
      assert {:error, response} = Completion.create(engine_id)

      assert String.match?(
               get_in(response.body, ["error", "message"]),
               ~r/^You didn't provide an API key./
             )
    end
  end
end
