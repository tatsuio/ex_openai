defmodule ExOpenAITest do
  use ExUnit.Case
  doctest ExOpenAI

  test "greets the world" do
    assert ExOpenAI.hello() == :world
  end
end
